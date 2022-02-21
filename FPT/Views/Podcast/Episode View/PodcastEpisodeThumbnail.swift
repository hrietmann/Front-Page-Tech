//
//  PodcastEpisodeThumbnail.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI
import YouTubePlayerKit


struct PodcastEpisodeThumbnail: View {
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    var isPlaying: Bool { podcast.isPlaying(episode.episode) }
    
    var body: some View {
        Color.clear
            .overlay { thumbnailPlayer }
    }
    
    var thumbnailPlayer: some View {
        Color(uiColor: .tertiarySystemFill)
            .shimmering(active: podcast.podcast?.artwork == nil)
            .frame(maxWidth: .infinity)
            .aspectRatio(episode.episode.video != nil ? 16/9 : 1, contentMode: .fit)
            .overlay { thumbnailImage }
            .overlay { thumbnailVideoPlayer }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.secondary, lineWidth: 0.2)
            }
            .scaleEffect(isPlaying ? 1 : 0.85)
            .shadow(
                color: (podcast.podcast?.colors.background ?? .black).opacity(isPlaying ? 0.5 : 0.2),
                radius: 18, x: 8, y: 10)
            .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.7), value: isPlaying)
            .animation(.easeIn.delay(1), value: podcast.podcast?.artwork)
            .animation(.easeIn.delay(1), value: episode.episode.video?.thumbnailURL)
    }
    
    @ViewBuilder
    var thumbnailVideoPlayer: some View {
        if let player = podcast.player as? PodcastVideoPlayer,
           let thumbnailURL = episode.episode.video?.thumbnailURL {
            YouTubePlayerView(player.player) { state in
                if podcast.isLoadingPlay {
                    SwiftUI.AsyncImage(url: thumbnailURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.scale(scale: 1.1, anchor: UnitPoint.center)
                                            .combined(with: .opacity))
                    } placeholder: {
                        Color.clear
                    }
                } else { EmptyView() }
            }
        } else { EmptyView() }
    }
    
    @ViewBuilder
    var thumbnailImage: some View {
        if let thumbnailURL = episode.episode.video?.thumbnailURL {
            SwiftUI.AsyncImage(url: thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .transition(.scale(scale: 1.1, anchor: UnitPoint.center)
                                    .combined(with: .opacity))
            } placeholder: {
                Color.clear
            }
        }
        else if let image = podcast.podcast?.artwork {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .transition(.scale(scale: 1.1, anchor: UnitPoint.center).combined(with: .opacity))
        } else {
            Image("podcast")
                .resizable()
                .scaledToFill()
                .transition(.scale(scale: 1.1, anchor: UnitPoint.center).combined(with: .opacity))
        }
    }
}

struct PodcastEpisodeThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeThumbnail()
    }
}
