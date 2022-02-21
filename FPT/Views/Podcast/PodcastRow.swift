//
//  PodcastRow.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import SwiftUIX
import ViewKit
import Shimmer

struct PodcastRow: View {
    
    let episode: PodcastEpisode?
    @State private var presentNotWorkedFeature = false
    @EnvironmentObject private var model: PodcastViewModel
    
    init() {
        episode = nil
    }
    init(episode: PodcastEpisode) {
        self.episode = episode
    }
    
    var body: some View {
        content
            .foregroundColor(.label)
            .background(.systemBackground)
            .onTapGesture {
                guard let episode = episode else { return }
                model.presentedEpisode = episode
            }
    }
    
    var content: some View {
        VStack(spacing: 16) {
            if episode?.video != nil {
                thumbnail
            }
            
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text((episode?.date ?? Date()).timeAgo.uppercased())
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundColor(.secondary)
                    Text(episode?.completeTitle ?? "Title missing")
                        .font(.headline)
                        .bold()
                        .lineLimit(1)
                    if let summary = episode?.summary {
                        Text(summary.trimmingCharacters(in: .newlines))
                            .font(.footnote)
                            .lineLimit(3)
                            .foregroundColor(Color(.tertiaryLabel))
                    }
                    Text((episode?.duration ?? 0).duration)
                        .font(.footnote)
                        .foregroundColor(.pink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                
                Button(action: {
                    guard let episode = episode else {
                        return
                    }
                    model.presentedEpisode = episode
                    if model.playerState.isPlaying { model.pause(episode: episode) }
                }) {
                    Image(systemName: model.playerState.episode?.id == episode?.id && model.playerState.isPlaying ? "pause.fill": "play.fill")
                        .font(Font.caption.bold())
                        .foregroundColor(.pink)
                        .padding(8)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(Circle())
                }
            }
            .padding(.trailing)
            Divider()
        }
        .padding(.leading)
        .padding(.top)
    }
    
    var thumbnail: some View {
        Color(uiColor: .tertiarySystemFill)
            .frame(maxWidth: .infinity)
            .aspectRatio(16/9, contentMode: .fit)
            .overlay {
                SwiftUI.AsyncImage(url: episode?.video?.thumbnailURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color(uiColor: .tertiarySystemFill)
                        .shimmering()
                }
            }
            .overlay(
                Button {
                    guard let episode = episode else {
                        return
                    }
                    model.presentedEpisode = episode
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title3)
                        .padding()
                        .background {
                            VisualEffectBlurView(blurStyle: .systemMaterial)
                        }
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.secondaryLabel, lineWidth: 0.3)
                        }
                }
                    .buttonStyle(BounceButtonStyle())
                    .shadow(radius: 8)
            )
            .cornerRadius(8)
            .padding(.trailing)
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow()
            .environmentObject(PodcastViewModel())
    }
}
