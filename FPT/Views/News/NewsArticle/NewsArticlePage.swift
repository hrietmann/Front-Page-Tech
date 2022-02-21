//
//  NewsArticlePage.swift
//  FPT
//
//  Created by Hans Rietmann on 20/02/2022.
//

import SwiftUI
import Shimmer



struct NewsArticlePage: View {
    
    @EnvironmentObject private var model: ArticleManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                NewsArticlePageHeader()
                loadingView
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay {
            closeButton
        }
    }
    
    var loadingView: some View {
        Group {
            Text("Jon Prosser, better known online as FRONT PAGE TECH (FPT), is an American technology news show on YouTube. Front Page Tech is semi-daily news show that uploads mainstream news and leaks about technology with a comedic twist.")
                .padding()
                .padding()
            
            Color.secondarySystemFill
                .aspectRatio(16/9, contentMode: .fill)
            
            Text("Jon Prosser, better known online as FRONT PAGE TECH (FPT), is an American technology news show on YouTube.")
                .padding()
                .padding()
            
            Text("Jon Prosser, better known online as FRONT PAGE TECH (FPT), is an American technology news show on YouTube. Front Page Tech is semi-daily news show that uploads")
                .padding()
                .padding()
            
            Color.secondarySystemFill
                .aspectRatio(1/1, contentMode: .fill)
            
            Text("Jon Prosser, better known online as FRONT PAGE TECH (FPT), is an American technology news show on YouTube.")
                .padding()
                .padding()
        }
        .redacted(reason: .placeholder)
        .shimmering()
    }
    
    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline, weight: .bold)
                .accentColor(.white)
                .padding(12)
                .background(.ultraThickMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.secondarySystemFill, lineWidth: 0.8)
                }
        }
        .buttonStyle(.bounce(scale: 0.8))
        .shimmering(active: false)
        .redacted(reason: [])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct NewsArticlePage_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticlePage()
            .environmentObject(ArticleManager(feed: nil, test: true))
    }
}
