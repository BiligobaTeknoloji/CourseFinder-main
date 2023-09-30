import SwiftUI

struct EditCourseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Course.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Course.courseName, ascending: true)]
    ) private var courses: FetchedResults<Course>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(courses, id: \.self) { course in
                    VStack(alignment: .leading) {
                        Text(course.courseName ?? "")
                            .font(.headline)
                        Text(course.courseCode ?? "")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteCourses)
            }
            .navigationBarTitle("Edit Courses", displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteCourses(at offsets: IndexSet) {
        for index in offsets {
            let course = courses[index]
            viewContext.delete(course)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    EditCourseView()
}
