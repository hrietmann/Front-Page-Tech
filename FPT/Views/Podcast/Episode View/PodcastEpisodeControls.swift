//
//  PodcastEpisodeControls.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeControls: View {
    
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    
    var body: some View {
        HStack {
            Spacer()
            Button(systemImage: .init(rawValue: "gobackward.15")!) {
                podcast.seekBackward(15)
            }
            .font(.title)
            .disabled(podcast.playerState.episode?.id != episode.episode.id)
            Spacer()
            if podcast.isLoadingPlay {
                ProgressView()
                    .frame(width: 16 * 2, height: 16 * 2)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Button(systemImage: .init(rawValue: podcast.isPlaying(episode.episode) ? "pause.fill": "play.fill")!) {
                    podcast.playPause(episode: episode.episode)
                    podcast.set(rate: episode.rate)
                }
                .font(.largeTitle, weight: .bold)
                .scaleEffect(1.2)
                .transition(.scale.combined(with: .opacity))
            }
            Spacer()
            Button(systemImage: .init(rawValue: "goforward.15")!) {
                podcast.seekForward(15)
            }
            .font(.title)
            .disabled(podcast.playerState.episode?.id != episode.episode.id)
            Spacer()
        }
        .animation(.easeInOut, value: podcast.isLoadingPlay)
        .animation(.easeOut, value: podcast.playerState.episode?.id != episode.episode.id)
        .foregroundColor(.label)
        .buttonStyle(.bounce(scale: 0.8, animation: .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.8)))
        .frame(height: 16 * 10)
    }
}

struct PodcastEpisodeControls_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeControls()
    }
}
