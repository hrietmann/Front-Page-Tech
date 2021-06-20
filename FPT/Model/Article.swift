//
//  Article.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import Foundation




struct Article: Identifiable {
    let id = UUID()
    let image: String
    let subtitle: String
    let title: String
    let creation: Date
    let creator: String
    
    static let list = [
        Article(image: "content1", subtitle: "Apple", title: "EXCLUSIVE: First Look at Newly Redesigned iPad mini 6", creation: Date.adding(days: -3), creator: "Jon Prosser"),
        Article(image: "content2", subtitle: "Android", title: "EXCLUSIVE: Samsung Galaxy Watch 4 Launching August 11th", creation: Date.adding(days: -3), creator: "Jon Prosser"),
        Article(image: "content3", subtitle: "Android", title: "EXCLUSIVE: Samsung Galaxy Z Fold 3 & Flip 3 Launching August 27th", creation: Date.adding(days: -3), creator: "Jon Prosser"),
        Article(image: "content4", subtitle: "Apple", title: "UPDATE! EXCLUSIVE: Beats Studio Buds announcement imminent, priced at $149.99", creation: Date.adding(days: -3), creator: "Jon Prosser"),
        Article(image: "content5", subtitle: "Apple", title: "Beats Studio Buds officially announced! $149.99, three colors, releasing on June 25", creation: Date.adding(days: -3), creator: "Jon Prosser")
    ]
}



extension Date {
    static func string(_ isoDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd-MM-yyyy"
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


extension TimeInterval {
    var duration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 3
        return formatter.string(from: self)!
    }
}
