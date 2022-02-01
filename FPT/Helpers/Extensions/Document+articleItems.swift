//
//  Document+articleItems.swift
//  FPT
//
//  Created by Hans Rietmann on 01/08/2021.
//

import Foundation
import SwiftSoup
import SwiftUI





extension Document {
    
    
    func articlePublicURL() throws -> URL? {
        guard let link = try head()?
            .getElementsByAttributeValue("property", "og:url")
            .first()?.attr("content")
        else { return nil }
        return URL(string: link)
    }
    
    
    func articleHeadImage() throws -> URL? {
        guard let link = try head()?
            .getElementsByAttributeValue("property", "og:image")
            .first()?.attr("content")
        else { return nil }
        return URL(string: link)
    }
    
    
    func articleTitle() throws -> String? {
        try head()?
            .getElementsByAttributeValue("property", "og:title")
            .first()?.attr("content")
    }
    
    
    func articleDescription() throws -> String? {
        return try head()?
            .getElementsByAttributeValue("property", "og:description")
            .first()?.attr("content")
    }
    
    
    func articleCreation() throws -> Date? {
        guard let string = try head()?
            .getElementsByAttributeValue("property", "article:published_time")
            .first()?.attr("content")
        else { return nil }
        return Date.string(string, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
    
    
    func articleUpdateDate() throws -> Date? {
        guard let string = try head()?
            .getElementsByAttributeValue("property", "article:published_time")
            .first()?.attr("content")
        else { return nil }
        return Date.string(string, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
    
    
    func authorName() throws -> String? {
        try head()?
            .getElementsByAttributeValue("name", "twitter:data1")
            .first()?.attr("content")
    }
    
    
    func articleAuthorImage() throws -> URL? {
        guard let link = try body()?
            .getElementsByAttributeValue("class", "avatar avatar-40 photo")
            .first()?.attr("src")
        else { return nil }
        return URL(string: link)
    }
    
    
    func articleItems() throws -> [ArticleContent] {
        var items = [ArticleContent]()
//        let article = try body()?.getElementsByTag("article").first()
//        let articleContent = try body()?.getElementsByClass("zox-article-wrap zoxrel left zox100").first()
//        let articleHeader = try body()?.getElementsByClass("zox-post-top-wrap zoxrel left zox100").first()
//        let articleBodyHeader = try body()?.getElementsByClass("zox-post-bot-wrap").first()
        let articleBodyContent = try body()?.getElementsByClass("zox-post-body left zoxrel zox100").first()
        let articleBodyContentItems = try articleBodyContent?
            .children()
            .compactMap { child -> ArticleContent? in
                
                // Image
                if let image = try child.getElementsByTag("img").first(),
                   let url = URL(string: try image.attr("src")),
                   let width = Double(try image.attr("width")),
                   let height = Double(try image.attr("height")),
                   let caption = try child.getElementsByTag("figcaption").first()?.text() {
                    return Article.Image(url: url, size: .init(width: width, height: height), caption: caption)
                }
                
                // Paragraph
                let paragraph = try child.getElementsByTag("p")
                let text = try paragraph.text()
                var paragraphItems = [ArticleParagraphContent]()
                if !paragraph.isEmpty() {
                    return Article.Paragraph(items: paragraphItems)
                }
                
                // Quote
                if child.tagName() == "blockquote" {
                    
                }
                return nil
        } ?? []
        items.append(contentsOf: articleBodyContentItems)
        let articleFooter = try body()?.getElementsByClass("zox-post-more-wrap left zoxrel zox100").first()
        return items
    }
    
    
}




fileprivate struct ArticleTestView: View {
    let article = Article.test
    
    var body: some View {
        VStack {
            ForEach(article.contentItems.indices, id: \.self) { index in
                if let paragraph = article.contentItems[index] as? Article.Paragraph {
                    paragraph.view
                }
            }
        }
    }
}

fileprivate struct ArticleTest_Previews: PreviewProvider {
    static var previews: some View {
        ArticleTestView()
    }
}
