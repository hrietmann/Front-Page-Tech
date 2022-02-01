//
//  Article+dummy.swift
//  FPT
//
//  Created by Hans Rietmann on 01/08/2021.
//

import Foundation



extension Article {
    
    
    
    fileprivate init(dummy title: String, subtitle: String) {
        self.id = .init()
        self.url = URL(string: "https://www.frontpagetech.com")!
        self.imageURL = URL(string: "https://www.frontpagetech.com/wp-content/uploads/2021/06/flippyboi3.jpg")
        self.title = title
        self.subtitle = subtitle
        self.description = nil
        self.createdAt = Date.adding(days: -3)
        self.updatedAt = nil
        self.author = "Jon Prosser"
        self.authorImageURL = URL(string: "https://www.frontpagetech.com/wp-content/uploads/2021/03/avatar-jon.png")
        self.contentItems = []
    }
    
    
    static let list = [
        Article(dummy: "EXCLUSIVE: First Look at Newly Redesigned iPad mini 6", subtitle: "Apple"),
        Article(dummy: "EXCLUSIVE: Samsung Galaxy Watch 4 Launching August 11th", subtitle: "Android"),
        Article(dummy: "EXCLUSIVE: Samsung Galaxy Z Fold 3 & Flip 3 Launching August 27th", subtitle: "Android"),
        Article(dummy: "UPDATE! EXCLUSIVE: Beats Studio Buds announcement imminent, priced at $149.99", subtitle: "Apple"),
        Article(dummy: "Beats Studio Buds officially announced! $149.99, three colors, releasing on June 25", subtitle: "Apple")
    ]
    
    
    
}
