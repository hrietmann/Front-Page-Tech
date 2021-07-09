//
//  NewsFeed.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import FeedKit

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
                case .waiting, .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .transition(.opacity.combined(with: .offset(y: 16)))
                case .failure(let error):
                    Text(error.localizedDescription)
                        .transition(.opacity.combined(with: .offset(y: 16)))
                case .success(let items):
                    content(articles: nil, items: items)
                        .transition(.opacity.combined(with: .offset(y: 16)))
                }
            }
        }
        .animation(.spring())
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
//                if let items = items {
//                    ForEach(items) { item in
//                        ArticleView(item: item)
//                            .opacity(didAppear ? 1:0)
//                            .offset(y: didAppear ? 0:100)
//                            .transition(.identity)
//                    }
//                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Designed by Hans in 🇫🇷")
                    Text("All rights reserved.")
                }
                .font(.caption2)
                .foregroundColor(Color(.tertiaryLabel))
                .frame(height: 16 * 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 16 * 2)
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
