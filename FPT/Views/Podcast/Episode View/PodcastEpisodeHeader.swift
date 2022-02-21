//
//  PodcastEpisodeHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeHeader: View {
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    var body: some View {
        Group {
            if let error = podcast.playError {
                ErrorView(error: error.localizedDescription) {
                    .init {
                        podcast.play(episode: episode.episode)
                    }
                }
            } else {
                Button {
                    podcast.playPause(episode: episode.episode)
                } label: {
                    PodcastEpisodeThumbnail()
                }
                .buttonStyle(.bounce(scale: 0.9))
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .padding(16 * 2)
    }
}

struct PodcastEpisodeHeader_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeHeader()
    }
}
