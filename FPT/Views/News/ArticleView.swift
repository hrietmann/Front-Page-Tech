//
//  ArticleView.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI

struct ArticleView: View {
    
    let article: Article
    var namespace: Namespace.ID
    @State private var isSource = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4)) {
                HomeManager.shared.showArticle = article
                isSource = true
            }
        }) { content }
        .foregroundColor(Color(.label))
        .buttonStyle(BounceButtonStyle())
        .onReceive(HomeManager.shared.$showArticle) { article in
            guard article == nil && isSource else { return }
            withAnimation(.spring()) {
                isSource = false
            }
        }
    }
    
    var content: some View {
        ZStack {
            Image(article.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.trailing, 32)
                .matchedGeometryEffect(id: "\(article.id.uuidString)Image", in: namespace, isSource: isSource)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.subtitle.uppercased())
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink)
                Text(article.title.uppercased())
                    .font(.headline)
                    .fontWeight(.heavy)
                    .lineLimit(2)
                HStack {
                    Text(article.creator)
                    Spacer()
                    Text(article.creation.timeAgo)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            .padding()
            .background(Color(.secondarySystemBackground))
            .shadow(radius: 16)
            .offset(y: 16 * 4)
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .matchedGeometryEffect(id: "\(article.id.uuidString)Text", in: namespace, isSource: isSource)
        }
        .animation(.spring(response: 0.4))
        .matchedGeometryEffect(id: "\(article.id.uuidString)Card", in: namespace, isSource: isSource)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: .list[0], namespace: Namespace.init().wrappedValue)
    }
}
