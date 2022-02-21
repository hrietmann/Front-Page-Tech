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




struct Article: Identifiable, Equatable {
    
    
    
    let id: String
    let url: URL
    let imageURL: URL?
    let title: String
    let subtitle: String
    let description: String?
    let createdAt: Date
    let updatedAt: Date?
    let author: String
    let authorImageURL: URL?
    let contentItems: [ArticleContent]
    
    
    init(from html: String, of item: RSSFeedItem) throws {
        let doc = try SwiftSoup.parse(html)
        id = item.id
        let itemURL = item.link == nil ? nil:URL(string: item.link!)
        url = try itemURL ?? doc.articlePublicURL() ?? URL(string: "https://www.frontpagetech.com")!
        imageURL = try doc.articleHeadImage()
        title = try item.title ?? doc.articleTitle() ?? "Unknown"
        subtitle = item.categories?.last?.value ?? "Miscellaneous"
        description = try item.description ?? doc.articleDescription() ?? "No description found."
        createdAt = try item.pubDate ?? doc.articleCreation() ?? Date()
        updatedAt = try doc.articleUpdateDate()
        author = try doc.authorName() ?? item.author ?? "FrontPageTech.com"
        authorImageURL = try doc.articleAuthorImage()
        contentItems = try doc.articleItems()
    }
    
    
    static var test: Article = {
        let fileURL = Bundle.main.url(forResource: "ArticleHTML", withExtension: "html")!
        let content = try! String(contentsOf: fileURL)
        return try! .init(html: content)
    }()
    
    
    private init(html: String) throws {
        let doc = try SwiftSoup.parse(html)
        id = UUID().uuidString
        url = try doc.articlePublicURL() ?? URL(string: "https://www.frontpagetech.com")!
        imageURL = try doc.articleHeadImage()
        title = try doc.articleTitle() ?? "Unknown"
        subtitle = "Unknown"
        description = try doc.articleDescription() ?? "No description found."
        createdAt = try doc.articleCreation() ?? Date()
        updatedAt = try doc.articleUpdateDate()
        author = try doc.authorName() ?? "FrontPageTech.com"
        authorImageURL = try doc.articleAuthorImage()
        contentItems = try doc.articleItems()
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    
}
