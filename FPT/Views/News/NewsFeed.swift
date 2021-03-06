//
//  NewsFeed.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import FeedKit
import Shimmer



struct NewsFeed: View {
    
    @State private var didAppear = false
    let articles: [Article]?
    @StateObject var manager: NewsFeedManager
    
    
    init(dummies articles: [Article]) {
        self.articles = articles
        _manager = StateObject(wrappedValue: .init(feed: .exclusives))
    }
    
    init(feed: NewsFeedManager.Feed) {
        articles = nil
        _manager = StateObject(wrappedValue: .init(feed: feed))
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Content Placeholder
            if let articles = articles {
                content(articles: articles, items: nil)
            } else {
                switch manager.state {
                case .waiting, .loading: loadView
                case .failure(let error):
                    ErrorView(error: error.localizedDescription)
                    { .init(completion: manager.load) }
//                    content(articles: nil, items: nil)
//                        .transition(.opacity.combined(with: .offset(y: 16)))
                case .success(let items):
                    content(articles: nil, items: items)
                        .transition(.opacity.combined(with: .offset(y: 16)))
                }
            }
        }
        .animation(.spring(), value: manager.state)
        .onAppear {
            withAnimation(Animation.easeOut(duration: 1.2)) {
                didAppear.toggle()
            }
        }
        .onDisappear {
            withAnimation(Animation.easeOut(duration: 1.2)) {
                didAppear.toggle()
            }
        }
    }
    
    var loadView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16 * 6) {
                ForEach(0..<10, id: \.self) { i in
//                    ArticleView(item: nil)
                    NewsArticleCell(test: false)
                        .opacity(didAppear ? 1:0)
                        .offset(y: didAppear ? 0:100)
                        .transition(.identity)
                }
            }
            .padding(.vertical, 16 * 2)
            .padding(.trailing)
            .transition(.opacity.combined(with: .offset(y: 16)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
        .redacted(reason: [.placeholder])
        .shimmering()
    }
    
    func content(articles: [Article]?, items: [RSSFeedItem]?) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16 * 6) {
                if let articles = manager.state.result {
                    ForEach(0..<articles.count, id: \.self) { i in
                        ArticleView(item: articles[i])
                            .opacity(didAppear ? 1:0)
                            .offset(y: didAppear ? 0:100)
                            .transition(.identity)
                    }
                }
                else if let items = items {
                    ForEach(items) { item in
                        NewsArticleCell(feedItem: item)
//                        ArticleView(item: item)
                            .opacity(didAppear ? 1:0)
                            .offset(y: didAppear ? 0:100)
                            .transition(.identity)
                    }
                } else {
                    NewsArticleCell(test: true)
                        .opacity(didAppear ? 1:0)
                        .offset(y: didAppear ? 0:100)
                        .transition(.identity)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Designed by Hans in ????????")
                    Text("All rights reserved.")
                }
                .font(.caption2)
                .foregroundColor(Color(.tertiaryLabel))
                .frame(height: 16 * 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 16 * 2)
            .padding(.trailing)
        }
        .coordinateSpace(name: "NewsFeed.ScrollView")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NewsFeed_Previews: PreviewProvider {
    static var previews: some View {
//        NewsFeed(namespace: Namespace().wrappedValue, articles: Article.list)
        HomeView()
            .preferredColorScheme(.dark)
    }
}
