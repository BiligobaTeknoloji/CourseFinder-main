//
//  ContentView.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/28/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        if currentPage > totalPages{
            HomeView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}



