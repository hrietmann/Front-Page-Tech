//
//  Date.swift
//  FPT
//
//  Created by Hans Rietmann on 28/06/2021.
//

import Foundation



extension Date {
    static func string(_ isoDate: String, format: String = "dd-MM-yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        return dateFormatter.date(from:isoDate)!
    }
    static func adding(days: Double) -> Date {
        return Date().addingTimeInterval(days * 24 * 60 * 60)
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

