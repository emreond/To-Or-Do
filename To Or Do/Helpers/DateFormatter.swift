//
//  DateFormatter.swift
//  To Or Do Project
//
//  Created by Emre on 22.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation

class DateFormatterHelper: NSObject {
    
    static let instance = DateFormatterHelper()
    let formatter = DateFormatter()
    
    // Formats the date chosen with the date picker.
    func formatDateForDisplay(date: Date) -> String {
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func dateFromString(string: String) -> Date?{
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.date(from: string)
    }
}
