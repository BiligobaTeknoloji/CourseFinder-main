//
//  AddCourseView.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/30/23.
//


import SwiftUI

struct AddCourseView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State private var courseName: String = ""
    @State private var courseCode: String = ""
    @State private var courseLocation: String = ""
    @State private var courseSection: String = ""
    @State private var selectedDay1: String = "Monday"
    @State private var selectedDay2: String = "Monday"
    @State private var selectedStartTime1: String = "09:30"
    @State private var selectedEndTime1: String = "10:20"
    @State private var selectedStartTime2: String = "09:30"
    @State private var selectedEndTime2: String = "10:20"
    @State private var showSecondDaySection: Bool = false
    @State private var selectedColor: Color = Color.blue
    @Environment(\.dismiss) var dismiss
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    let startTimes = ["09:30", "10:30", "11:30", "12:30", "13:30", "14:30", "15:30", "16:30"]
    let endTimes = ["10:20", "11:20", "12:20", "13:20", "14:20", "15:20", "16:20", "17:20"]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Course Name", text: $courseName)
                        TextField("Course Code", text: $courseCode)
                            .textInputAutocapitalization(.characters)
                        TextField("Course Section", text: $courseSection)
                            .keyboardType(.numberPad)
                        TextField("Course place Like : B1010", text: $courseLocation)
                    } header: {
                        Text("Course Info")
                    }
                    
                    Section {
                        Picker("Day", selection: $selectedDay1) {
                            ForEach(daysOfWeek, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("Start Time", selection: $selectedStartTime1) {
                            ForEach(startTimes, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("End Time", selection: $selectedEndTime1) {
                            ForEach(endTimes, id: \.self) {
                                Text($0)
                            }
                        }
                        
                    } header: {
                        Text("First Day")
                    }
                    
                    if showSecondDaySection {
                        Section {
                            Picker("Day", selection: $selectedDay2) {
                                ForEach(daysOfWeek, id: \.self) {
                                    Text($0)
                                }
                            }
                            
                            Picker("Start Time", selection: $selectedStartTime2) {
                                ForEach(startTimes, id: \.self) {
                                    Text($0)
                                }
                            }
                            
                            Picker("End Time", selection: $selectedEndTime2) {
                                ForEach(endTimes, id: \.self) {
                                    Text($0)
                                }
                            }
                            
                        } header: {
                            Text("Second Day")
                        }
                        
                    }
                    
                    Button(action: {
                        withAnimation {
                            showSecondDaySection.toggle()
                        }
                    }) {
                        Text(showSecondDaySection ? "Remove Second Day" : "Add Second Day")
                    }
                    
                    Section {
                        ColorPicker("Select Course Color", selection: $selectedColor)
                    }
                }
            }
            .navigationTitle("Add Course")
            .toolbar(content: {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let course = Course(context: moc)
                        course.id = UUID()
                        course.courseName = courseName
                        course.courseCode = courseCode
                        course.courseSec = courseSection
                        course.coursePlace = courseLocation
                        course.courseColor = selectedColor.hex

                        let courseDay1 = CourseDay(context: moc)
                        courseDay1.dayOfWeek = selectedDay1
                        courseDay1.startTime = selectedStartTime1
                        courseDay1.endTime = selectedEndTime1
                        course.addToDays(courseDay1)

                        if showSecondDaySection {
                            let courseDay2 = CourseDay(context: moc)
                            courseDay2.dayOfWeek = selectedDay2
                            courseDay2.startTime = selectedStartTime2
                            courseDay2.endTime = selectedEndTime2
                            course.addToDays(courseDay2)
                        }

                        do {
                            try moc.save()
                            dismiss()
                        } catch {
                            print("Failed to save course: \(error.localizedDescription)")
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            })
        }
    }
}



#Preview {
    AddCourseView()
}
