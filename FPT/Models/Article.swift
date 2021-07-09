//
//  Article.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import Foundation
import SwiftUI
import SwiftSoup
import FeedKit




struct Article: Identifiable {
    let id: String
    let url: URL
    let imageURL: URL?
    let title: String
    let subtitle: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date?
    let author: String
    
    init(from html: String, of item: RSSFeedItem) throws {
        let doc = try SwiftSoup.parse(html)
        self.id = item.id
        let itemURL = item.link == nil ? nil:URL(string: item.link!)
        let urlLink = try doc.head()?
            .getElementsByAttributeValue("property", "og:url")
            .first()?.attr("content")
        let url = urlLink == nil ? nil:URL(string: urlLink!)
        self.url = itemURL ?? url ?? URL(string: "https://www.frontpagetech.com")!
        let imageLink = try doc.head()?
            .getElementsByAttributeValue("property", "og:image")
            .first()?.attr("content")
        if let link = imageLink { imageURL = URL(string: link) }
        else { imageURL = nil }
        let title = try doc.head()?
            .getElementsByAttributeValue("property", "og:title")
            .first()?.attr("content")
        self.title = item.title ?? title ?? "Unknown"
        subtitle = item.categories?.last?.value ?? "Unknown"
        let description = try doc.head()?
            .getElementsByAttributeValue("property", "og:description")
            .first()?.attr("content")
        self.description = item.description ?? description ?? "No description found."
        let dateString = try doc.head()?
            .getElementsByAttributeValue("property", "article:published_time")
            .first()?.attr("content")
        let date = dateString == nil ? nil : Date.string(dateString!, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
        createdAt = item.pubDate ?? date ?? Date()
        let updatedString = try doc.head()?
            .getElementsByAttributeValue("property", "article:published_time")
            .first()?.attr("content")
        self.updatedAt = updatedString == nil ? nil : Date.string(updatedString!, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
        let author = try doc.head()?
            .getElementsByAttributeValue("name", "twitter:data1")
            .first()?.attr("content")
        self.author = item.author ?? author ?? "FrontPageTech.com"
    }
    
    fileprivate init(dummy title: String, subtitle: String) {
        self.id = .init()
        self.url = URL(string: "https://www.frontpagetech.com")!
        self.imageURL = nil
        self.title = title
        self.subtitle = subtitle
        self.description = nil
        self.createdAt = Date.adding(days: -3)
        self.updatedAt = nil
        self.author = "Jon Prosser"
    }
}




extension Article {
    
    static let list = [
        Article(dummy: "EXCLUSIVE: First Look at Newly Redesigned iPad mini 6", subtitle: "Apple"),
        Article(dummy: "EXCLUSIVE: Samsung Galaxy Watch 4 Launching August 11th", subtitle: "Android"),
        Article(dummy: "EXCLUSIVE: Samsung Galaxy Z Fold 3 & Flip 3 Launching August 27th", subtitle: "Android"),
        Article(dummy: "UPDATE! EXCLUSIVE: Beats Studio Buds announcement imminent, priced at $149.99", subtitle: "Apple"),
        Article(dummy: "Beats Studio Buds officially announced! $149.99, three colors, releasing on June 25", subtitle: "Apple")
    ]
    
}
