//
//  Item.swift
//  ExerciseTracker
//
//  Created by Mehmet Jiyan Atalay on 22.07.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    let month: Int
    let year: Int
    var exercises: [Exercises] = []
    var totalMinute = 0
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    static func getCurrentMonth() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.month, from: currentDate)
    }
        
    static func getCurrentYear() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: currentDate)
    }
    
    func getMonthName() -> String? {
        let locale = Locale(identifier: "tr_TR")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM"

        var components = DateComponents()
        components.month = month

        let calendar = Calendar.current
        if let date = calendar.date(from: components) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

struct Exercises : Codable, Identifiable {
    var id = UUID()
    var minute: Int
    var exerciseName: String
    var day : Int
}

