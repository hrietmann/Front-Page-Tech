//
//  ArticleView.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI
import ViewKit
import FeedKit
import Shimmer



struct ArticleView: View {
    
    @ObservedObject private var manager: ArticleManager
    @State private var frame = CGRect.zero
    @State private var present = false
    @Namespace var namespace
    
    init(item: RSSFeedItem?) {
        manager = ArticleManager(feed: item)
    }
    
    private var id: String {
        manager.article.result?.id ?? UUID().uuidString
    }
    private var subtitle: String {
        manager.article.result?.subtitle ?? "Subtitle"
    }
    private var title: String {
        manager.article.result?.title ?? "Here is a fake fahtahtah title just to have multiple lines. What do you thin ? That's long hu ?"
    }
    private var creator: String {
        manager.article.result?.author ?? "FrontPageTech.com"
    }
    private var date: String {
        manager.article.result?.createdAt.timeAgo ?? "No date found"
    }
    
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4)) {
//                HomeManager.shared.present(
//                    ArticlePage(manager: manager, thumbnail: $frame)
//                )
                present.toggle()
            }
        }) { content }
        .get(frame: $frame, in: .global/*.named("NewsFeed.ScrollView")*/, constantUpdate: true)
        .foregroundColor(Color(.label))
        .buttonStyle(BounceButtonStyle())
        .fullScreenCover(isPresented: $present) {
            OldVersion(manager: manager, namespace: namespace)
        }
    }
    
    var content: some View {
        ZStack {
//            if let article = manager.article.result {
//                ArticleImage(article: article)
//                    .aspectRatio(1.2, contentMode: .fill)
//                    .clipped()
//            }
            Color.clear
                .aspectRatio(contentMode: .fit)
                .aspectRatio(1.2, contentMode: .fill)
                .overlay(image)
                .frame(maxWidth: .infinity)
                .background(Color(.tertiarySystemFill))
//                .shimmering(active: manager.image.isLoading)
                .clipped()
                .padding(.trailing, 32)
                .animation(.spring())
//            if let item = rssItem {
//                ArticleImage(item: item)
//                    .aspectRatio(1.2, contentMode: .fill)
//                    .clipped()
//                    .padding(.trailing, 32)
//            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .lineLimit(1)
                Text(title.uppercased())
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .lineLimit(3)
                HStack {
                    Text(creator)
                    Spacer()
                    Text(date)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            .padding()
            .background(Color(.tertiarySystemBackground))
            .shadow(radius: 12)
            .offset(y: 16 * 4)
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .redacted(reason: manager.article.isLoading ? .placeholder:[])
        .animation(.spring(response: 0.4))
    }
    
    @ViewBuilder
    var image: some View {
//        if let image = manager.image.result {
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .transition(.opacity)
//        } else {
            EmptyView()
//        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(item: .init())
            .aspectRatio(contentMode: .fit)
    }
}
