//
//  PodcastEpisodeContentActions.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeContentActions: View {
    
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    
    var body: some View {
        HStack {
            SwiftUI.Menu {
                Button {
                    set(rate: 0.5)
                } label: {
                    Label("0.5x speed", systemImage: "tortoise")
                }
                Button {
                    set(rate: 0.75)
                } label: {
                    Label("0.75x speed", systemImage: "tortoise")
                }
                Button {
                    set(rate: 1)
                } label: {
                    Label("1x speed", systemImage: "figure.walk")
                }
                Button {
                    set(rate: 1.25)
                } label: {
                    Label("1.25x speed", systemImage: "hare")
                }
                Button {
                    set(rate: 1.5)
                } label: {
                    Label("1.5x speed", systemImage: "hare")
                }
                Button {
                    set(rate: 2)
                } label: {
                    Label("2x speed", systemImage: "hare")
                }
            } label: {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(episode.rate, format: .number)
                    Image(systemName: "xmark")
                        .font(.footnote, weight: .heavy)
                }
            }
            Spacer()
            Link(destination: podcast.podcast!.itunesURL) {
                Image("podcasts app").resizable().scaledToFit()
            }
            .frame(width: 30, height: 30)
            .buttonStyle(.bounce)
        }
        .overlay {
            if let youtubeURL = podcast.presentedEpisode?.video?.videoURL {
                Link(destination: youtubeURL) {
                    Image("youtube app").resizable().scaledToFit()
                }
                .frame(width: 32, height: 32)
                .buttonStyle(.bounce)
            }
        }
        .buttonStyle(.bounce)
        .foregroundColor(.accentColor)
        .font(.title3, weight: .bold)
        .padding(.horizontal, 16 * 2)
        .padding(.bottom, 16 * 2)
        .onReceive(podcast.$playingEpisodeRate) { rate in
            guard podcast.playerState.episode?.id == episode.episode.id else { return }
            episode.rate = rate
        }
    }
    
    func set(rate: Double) {
        if podcast.playerState.episode?.id == episode.episode.id { podcast.set(rate: rate) }
        episode.rate = rate
    }
}

struct PodcastEpisodeContentActions_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeContentActions()
    }
}
