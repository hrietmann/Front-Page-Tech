//
//  OldVersion.swift
//  FPT
//
//  Created by Hans Rietmann on 28/06/2021.
//

import SwiftUI
import ViewKit
import Shimmer




struct OldVersion: View {
    
    @ObservedObject var manager: ArticleManager
    @Environment(\.presentationMode) var presentationMode
    let namespace: Namespace.ID
    @State private var readyToClose = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            GeometryReader { geometry in
                Color.clear
                    .aspectRatio(contentMode: .fit)
                    .aspectRatio(1.4, contentMode: .fill)
                    .overlay(image)
                    .frame(maxWidth: .infinity)
                    .background(Color(.tertiarySystemFill))
//                    .shimmering(active: manager.image.isLoading)
                    .clipped()
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .blur(radius: self.getBlurRadiusForImage(geometry))
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }.frame(height: UIScreen.main.bounds.width * 0.85)
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    header
                        .padding(.bottom)
                    
                    ArticleWriter(article: manager.article.result)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    ArticleBody(article: manager.article.result)
                    
                    Spacer()
                        .frame(height: UIApplication.shared.windows[0].safeAreaInsets.bottom)
                }
            }
            .font(.footnote.weight(.medium))
            .padding(.top, -16 * 6)
        }
        .redacted(reason: manager.article.isLoading ? .placeholder:[])
        .edgesIgnoringSafeArea(.all)
        .overlay(closeButton)
        .transition(.opacity)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(.secondarySystemBackground))
        .onAppear {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
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
    
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(manager.article.result?.subtitle.uppercased() ?? Article.list[0].subtitle.uppercased())
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.pink)
                .lineLimit(1)
            Text(manager.article.result?.title.uppercased() ?? Article.list[0].title.uppercased())
                .font(.title3)
                .fontWeight(.heavy)
                .font(.headline)
                .foregroundColor(Color(.label))
        }
        .animation(.spring())
        .frame(width: UIScreen.main.bounds.width * 0.7)
        .padding()
        .background(Color(.tertiarySystemBackground))
        .shadow(radius: 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var closeButton: some View {
        Button(action: close, label: {
            Image(systemName: "xmark")
                .font(.subheadline.bold())
                .padding(8)
                .foregroundColor(.secondary)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Circle())
        })
            .scaleEffect(readyToClose ? 1.4:1)
            .animation(.spring(response: 0.3))
            .buttonStyle(BounceButtonStyle())
            .shadow(radius: 8)
            .padding()
            .padding(.top, UIApplication.shared.windows[0].safeAreaInsets.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func close() {
//        HomeManager.shared.dimissCurrentPage()
        presentationMode.wrappedValue.dismiss()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
    
    // at 0 offset our blur will be 0
    // at 300 offset our blur will be 6
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        handleCloseBehaviour(offset: offset)
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)
        return blur * 4 // Values will range from 0 - 6
    }
    
    private func handleCloseBehaviour(offset: CGFloat) {
        withAnimation(.spring(response: 0.4)) {
            let screenWidth = UIScreen.main.bounds.width
            if offset > screenWidth * 0.95 {
                if offset > screenWidth * 1.25 {
                    close()
                } else {
                    guard !readyToClose else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.readyToClose = true
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }
                }
            } else {
                guard readyToClose else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.readyToClose = false
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                }
            }
        }
    }
    
}

struct OldVersion_Previews: PreviewProvider {
    static var previews: some View {
//        OldVersion(manager: .init(feed: .init()), namespace: Namespace().wrappedValue)
        HomeView()
    }
}
