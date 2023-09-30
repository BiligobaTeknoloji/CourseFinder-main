//
//  MainView.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/30/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var isAddCourseViewPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center)
                    .blur(radius: 4)
                    .ignoresSafeArea()
                
                
                ScrollView {
                    VStack {
                        HStack {
                            Text("Control your\nCourses & Exams")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Image("mainimage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150)
                                .offset(x: 10)
                        }
                        .padding()
                        
                        
                        
                        Spacer(minLength: 50)
                        
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                Button(action: {
                                    isAddCourseViewPresented.toggle()  // Toggle the state variable to show the sheet
                                }) {
                                    ActionCard(title: "Add Courses", icon: "book.fill", bgColor: .blue, image: "study1")
                                }
                                .sheet(isPresented: $isAddCourseViewPresented) {
                                    AddCourseView()  // Your AddCourseView is presented as a sheet
                                }
                                
                                NavigationLink {
                                    EditCourseView()
                                } label: {
                                    ActionCard(title: "Edit Courses", icon: "pencil.circle.fill", bgColor: .green, image:"addcourse1")
                                }
                                
                                
                            }
                            .padding()
                            
                            HStack(spacing: 20) {
                                
                                NavigationLink {
                                    Text("Coming Soon")
                                } label: {
                                    ActionCard(title: "Add Exams", icon: "calendar.badge.plus", bgColor: .orange, image: "exam")
                                }
                                
                                NavigationLink {
                                    Text("Coming Soon")
                                } label: {
                                    ActionCard(title: "Add Homeworks", icon: "doc.text.fill", bgColor: .pink, image: "addhome")
                                    
                                }
                                
                            }
                            .padding(.top, 60)
                        }
                        .padding()
                        .padding(.horizontal)
                        
                        Spacer(minLength: 10)
                    }
                }
            }
        }
    }
}

struct ActionCard: View {
    var title: String
    var icon: String
    var bgColor: Color
    var image : String
    
    var body: some View {
        ZStack {
            bgColor
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            
            VStack {
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 20)
            }
            .frame(width: 150, height: 150)
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: -75)  // Adjust this offset to position the image as needed
        }
        .frame(width: 150, height: 150)
    }
}


#Preview {
    MainView()
}
