//
//  NewsFeed.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct NewsFeed: View {
    
    @State private var didAppear = false
    var namespace: Namespace.ID
    let articles: [Article]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Content Placeholder
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16 * 6) {
                    if !articles.isEmpty {
                        ForEach(0..<articles.count, id: \.self) { i in
                            ArticleView(article: articles[i], namespace: namespace)
                                .opacity(didAppear ? 1:0)
                                .offset(y: didAppear ? 0:100)
                                .transition(.identity)
                        }
                    }
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NewsFeed_Previews: PreviewProvider {
    static var previews: some View {
//        NewsFeed(namespace: Namespace().wrappedValue, articles: Article.list)
        HomeView()
            .preferredColorScheme(.dark)
    }
}
