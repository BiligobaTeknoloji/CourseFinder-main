//
//  Courses.swift
//  CourseFinder
//
//  Created by Ali Amer on 9/30/23.
//

import Foundation
import SwiftUI
import CoreData

class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "Courses")
    
    init() {
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
    }
}

struct Courses: Identifiable {
    var id = UUID()
    var startTime: String
    var endTime: String
    var title: String
    var section: String
    var location: String
    var code : String
    var bgColor : Color
}


extension Color {
    var hex: String {
        let components = self.cgColor!.components!
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
