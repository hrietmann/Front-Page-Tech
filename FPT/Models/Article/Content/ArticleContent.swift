//
//  ArticleContent.swift
//  FPT
//
//  Created by Hans Rietmann on 01/08/2021.
//

import SwiftUI
import ViewKit



protocol ArticleContent {
    
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


extension Article {
    struct Paragraph: ArticleContent {
        let items: [ArticleParagraphContent]
        
        var view: AttributedText {
            let mutable = NSMutableAttributedString()
            items.forEach { mutable.append($0.attributes) }
            return .init(mutable)
        }
    }
}


protocol ArticleParagraphContent {
    var text: String { get }
    var attributes: NSAttributedString { get }
}

extension Article.Paragraph {
    struct Text: ArticleParagraphContent {
        let text: String
        let isBold: Bool
        let isItalic: Bool
        var attributes: NSAttributedString {
            .init(string: text, attributes: [
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
            ])
        }
    }

    struct Link: ArticleParagraphContent {
        let url: URL
        let text: String
        var attributes: NSAttributedString {
            .init(string: text, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(Color.accentColor),
                NSAttributedString.Key.kern: 0.2,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)
            ])
        }
    }
}

extension Article {
    
    
    
    struct Image: ArticleContent {
        let url: URL
        let size: CGSize
        let caption: String
    }
    
    
    struct Tweet: ArticleContent {
        
    }

    
    struct Quote: ArticleContent {
        let paragraph: Paragraph
        let cite: String
    }

    
    struct Video: ArticleContent {
        
    }
    
    
    
}
