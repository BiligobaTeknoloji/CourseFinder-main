//
//  ScheduleView.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/29/23.
//

import SwiftUI

struct ScheduleView: View {
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var selectedDay: String? = "Monday"
    
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.courseName, ascending: true)]
    ) var courses: FetchedResults<Course>
    
    var body: some View {
        VStack {
            Text("\(formattedDate)")
                .font(.title)
                .fontWeight(.semibold)
            
            DaySelectionView(selectedDay: $selectedDay)
            
            HeaderRow()
            
            if let selectedDay = selectedDay {
                CourseListView(selectedDay: selectedDay, courses: Array(courses))
            }
        }
        .padding(.leading)
    }
    
    var formattedDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

struct DaySelectionView: View {
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @Binding var selectedDay: String?
    
    static var today: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    init(selectedDay: Binding<String?>) {
        self._selectedDay = selectedDay
        if self.selectedDay == nil {
            self._selectedDay.wrappedValue = Self.today
        }
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day.prefix(3))
                    .padding()
                    .background(selectedDay == day ? Color.blue : Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedDay = day
                    }
            }
        }
    }
}

struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Time")
            Text("Course")
                .padding(.leading)
                .padding()
            Spacer()
        }
        .padding(.leading, 30)
    }
}

struct CourseListView: View {
    var selectedDay: String
    var courses: [Course]
    
    var filteredCourses: [(course: Course, days: [CourseDay])] {
        let courseDayTuples = courses.compactMap { course -> (course: Course, day: CourseDay)? in
            guard let daysSet = course.days as? Set<CourseDay>,
                  let day = daysSet.first(where: { $0.dayOfWeek == selectedDay }) else { return nil }
            return (course: course, day: day)
        }
        
        let sortedCourseDayTuples = courseDayTuples.sorted { tuple1, tuple2 in
            guard let hour1 = Int(tuple1.day.startTime?.split(separator: ":").first ?? ""),
                  let hour2 = Int(tuple2.day.startTime?.split(separator: ":").first ?? "") else { return false }
            return hour1 < hour2
        }
        
        return sortedCourseDayTuples.map { tuple in
            (course: tuple.course, days: [tuple.day])
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(filteredCourses, id: \.course.id) { item in
                    ForEach(item.days, id: \.self) { courseDay in
//                        let colorString = item.course.courseColor ?? "#000000"
//                        let color = Color(hex: colorString)
                        CourseRowView(course: item.course, courseDay: courseDay)
                    }
                }
            }
        }
    }
}




struct CourseRowView: View {
    var course: Course
    var courseDay: CourseDay
    
    var color: Color {
        Color(hex: course.courseColor ?? "#000000")
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: "clock")
                VStack {
                    Text(courseDay.startTime ?? "")
                    Text(courseDay.endTime ?? "")
                        .foregroundStyle(.secondary)
                }
                .padding(.trailing)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text(course.courseName ?? "")
                        .fontWeight(.semibold)
                    Text(course.courseCode ?? "")
                        .fontWeight(.semibold)
                    Text(" Sec - \(course.courseSec ?? "")")
                        .fontWeight(.semibold)
                    HStack {
                        Text("Class: \(course.coursePlace ?? "")")
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(color)
                .cornerRadius(12)
            }
        }
        .frame(height: 100)
    }
}


#Preview {
    ScheduleView()
}


extension String {
    var timeComponents: (hour: Int, minute: Int)? {
        let timeParts = self.split(separator: ":")
        guard timeParts.count == 2,
              let hour = Int(timeParts[0]),
              let minute = Int(timeParts[1]) else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
}

