//
//  NewsArticleCell.swift
//  FPT
//
//  Created by Hans Rietmann on 20/02/2022.
//

import SwiftUI
import FeedKit
import Shimmer


struct NewsArticleCell: View {
    
    @StateObject private var model: ArticleManager
    @State private var presentNewsArticle = false
    
    init(feedItem: RSSFeedItem) {
        _model = .init(wrappedValue: .init(feed: feedItem))
    }
    
    init(test: Bool = false) {
        _model = .init(wrappedValue: .init(feed: nil, test: test))
    }
    
    var body: some View {
        Button {
            presentNewsArticle = true
        } label: {
            ZStack(alignment: .init(horizontal: .center, vertical: .newsArticleCellImageAndTitle)) {
                articleImage
                    .alignmentGuide(.newsArticleCellImageAndTitle) { $0[.bottom] }
                    .padding(.trailing)
                    .padding(.bottom)
                
                articleDetails
                    .padding(.leading)
                    .padding(.leading)
            }
        }
        .foregroundColor(.label)
        .buttonStyle(.bounce)
        .fullScreenCover(isPresented: $presentNewsArticle) {
            NewsArticlePage()
        }
        .environmentObject(model)
    }
    
    var articleImage: some View {
        AsyncImage(
            url: model.article.result?.imageURL,
            transaction: .init(animation: .easeOut(duration: 0.5))) {
                switch $0 {
                case .success(let image):
                    Color(uiColor: .tertiaryLabel)
                        .overlay {
                            image.resizable().scaledToFill()
                        }
                        .clipped()
                        .transition(.opacity.combined(with: .scale(scale: 1.1)))
                case .failure(let error):
                    Text(error.localizedDescription)
                        .transition(.opacity.combined(with: .scale(scale: 1.1)))
                default:
                    Color(uiColor: .tertiaryLabel)
                        .transition(.opacity.combined(with: .scale(scale: 1.1)))
                        .shimmering()
                }
            }
            .aspectRatio(5/4, contentMode: .fit)
            .overlay {
                Rectangle().stroke(Color(uiColor: .tertiaryLabel), lineWidth: 0.3)
            }
    }
    
    var articleDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text((model.article.result?.subtitle ?? "categories").uppercased())
                .font(.footnote.weight(.heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.accentColor)
                .lineLimit(1)
            Text((model.article.result?.title ?? "title").uppercased())
                .font(.headline.weight(.heavy))
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .alignmentGuide(.newsArticleCellImageAndTitle) { d in d[VerticalAlignment.lastTextBaseline] }
            HStack {
                Text((model.article.result?.author ?? "author"))
                    .foregroundColor(.secondaryLabel)
                Spacer()
                Text(model.article.result?.createdAt ?? Date(), style: .relative)
                    .foregroundColor(.tertiaryLabel)
            }
            .font(.footnote, weight: .medium)
            .lineLimit(1)
        }
        .redacted(reason: model.article.result == nil ? .placeholder: [])
        .shimmering(active: model.article.result == nil)
        .padding()
        .background {
            Color(uiColor: .tertiarySystemBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 2, y: 4)
        }
        .overlay {
            Rectangle().stroke(Color(uiColor: .tertiaryLabel), lineWidth: 0.3)
        }
    }
}

struct NewsArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleCell(test: true)
            
            
    }
}


extension VerticalAlignment {
    
    fileprivate struct NewsArticleCellImageAndTitle: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }
    static let newsArticleCellImageAndTitle = VerticalAlignment(NewsArticleCellImageAndTitle.self)
    
}
