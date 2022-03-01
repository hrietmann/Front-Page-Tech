//
//  NewsArticlePageHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 21/02/2022.
//

import SwiftUI
import Shimmer
import ViewKit


struct NewsArticlePageHeader: View {
    
    @EnvironmentObject private var model: ArticleManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .init(horizontal: .center, vertical: .newsArticleCellImageAndTitle)) {
            GeometryReader { geometry in
                let _ = dismissIfNeeded(on: geometry)
                stretchyImage
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.frame(in: .global).minY <= 0 ? geometry.size.height:
                            geometry.size.height + geometry.frame(in: .global).minY
                    )
                    .clipped()
                    .offset(
                        y: geometry.frame(in: .global).minY <= 0 ?
                        geometry.frame(in: .global).minY/9 : -geometry.frame(in: .global).minY
                    )
            }
            .aspectRatio(1.2, contentMode: .fit)
            .alignmentGuide(.newsArticleCellImageAndTitle) { $0[VerticalAlignment.bottom] }
            
            titles
                .padding(.leading)
                .padding(.leading)
        }
    }
    
    func dismissIfNeeded(on geometry: GeometryProxy) {
        guard geometry.frame(in: .global).minY > 150 else { return }
        dismiss()
    }
    
    var stretchyImage: some View {
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
            .overlay {
                Rectangle().stroke(Color(uiColor: .tertiaryLabel), lineWidth: 0.3)
            }
    }
    
    var titles: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text((model.article.result?.subtitle ?? "categories").uppercased())
                .font(.subheadline.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.accentColor)
                .lineLimit(1)
            Text((model.article.result?.title ?? "title").uppercased())
                .font(.title3.weight(.heavy))
                .lineLimit(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .alignmentGuide(.newsArticleCellImageAndTitle) { d in d[VerticalAlignment.firstTextBaseline] }
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

struct NewsArticlePageHeader_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                NewsArticlePageHeader()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .environmentObject(ArticleManager(feed: nil, test: true))
    }
}
