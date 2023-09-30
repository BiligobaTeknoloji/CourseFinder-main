//
//  CourseFinderApp.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/28/23.
//

import SwiftUI

@main
struct CourseFinderApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
