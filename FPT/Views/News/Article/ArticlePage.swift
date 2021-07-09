//
//  ArticlePage.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI
import ViewKit
import FeedKit
import Shimmer



struct ArticlePage: View {
    
    @ObservedObject var manager: ArticleManager
    @Binding var thumbnail: CGRect
    @State private var appeared = false
    @State private var aniamtionProgression: CGFloat = 1.0
    
    
    
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
        GeometryReader { geometry in
            content
                .offset(x: appeared ? 0 : thumbnail.minX - geometry.frame(in: .global).minX,
                        y: appeared ? 0 : thumbnail.minY - geometry.frame(in: .global).minY)
            .onChange(of: thumbnail, perform: { newValue in
                print("Thumbnail origin : \(newValue.origin)")
                print("View origin : \(geometry.frame(in: .global).origin)")
            })
            .frame(width: appeared ? geometry.size.width : thumbnail.width,
                   height: appeared ? geometry.size.height : thumbnail.height)
            .transition(.offset())
            .onAppear {
                withAnimation(.spring()) {
                    aniamtionProgression = 1
                }
            }
        }
    }
    
    var content: some View {
        ZStack {
            
            Color.clear
                .aspectRatio(contentMode: .fit)
                .aspectRatio(1.2, contentMode: .fill)
                .overlay(image)
                .frame(maxWidth: .infinity)
                .background(Color(.tertiarySystemFill))
                .shimmering(active: manager.image.isLoading)
                .clipped()
                .padding(.trailing, 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        aniamtionProgression = 0
                    }
                }
                .onAnimationCompletion(for: aniamtionProgression) {
                    guard aniamtionProgression == 0 else { return }
                    HomeManager.shared.dimissCurrentPage()
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
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
    }
    
    @ViewBuilder
    var image: some View {
        if let image = manager.image.result {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
        } else {
            EmptyView()
        }
    }
    
}

struct ArticlePage_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePage(manager: .init(feed: .init()), thumbnail: .constant(.init(origin: .zero, size: .init(width: 200, height: 100))))
    }
}




/// An animatable modifier that is used for observing animations for a given animatable value.
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}


extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompletion<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}
