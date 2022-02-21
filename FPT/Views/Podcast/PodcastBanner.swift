//
//  PodcastBanner.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI
import Shimmer
import SwiftUIX



struct PodcastBanner: View {
    
    let episode: PodcastEpisode
    @EnvironmentObject private var model: PodcastViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 16) {
                thumbnail
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(episode.episodeNumber.uppercased())
                        .font(.footnote)
                        .foregroundColor(.tertiaryLabel)
                    Text(episode.wrappedTitlte)
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                
                Button {
                    model.seekBackward(15)
                } label: {
                    Image(systemName: "gobackward.15")
                }
                
                Button {
                    guard let episode = model.playerState.episode else { return }
                    if model.playerState.isPlaying { model.pause(episode: episode) }
                    else {
                        if episode.video != nil { model.presentedEpisode = episode }
                        else { model.play(episode: episode) }
                    }
                } label: {
                    Image(systemName: model.playerState.isPlaying ? "pause.fill":"play.fill")
                }
                .font(.title, weight: .bold)
                
                Button {
                    model.seekForward(15)
                } label: {
                    Image(systemName: "goforward.15")
                }
                
            }
            .font(.title2, weight: .medium)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .buttonStyle(.bounce(scale: 0.8))
            .onTapGesture {
                guard let episode = model.playerState.episode else { return }
                model.presentedEpisode = episode
            }
            
            ProgressView(value: model.playingEpisodeElapsedTime / (model.playerState.episode?.duration ?? 0))
                .tint(.accentColor)
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .transition(.move(edge: .bottom))
        .animation(.spring(), value: model.playerState.episode?.id)
    }
    
    
    var thumbnail: some View {
        Color.clear
            .frame(width: 55, height: 55)
            .overlay {
                if let thumbnailURL = model.playerState.episode?.video?.thumbnailURL {
                    SwiftUI.AsyncImage(url: thumbnailURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .aspectRatio(16/9, contentMode: .fit)
                            .cornerRadius(4, style: .continuous)
                    } placeholder: {
                        Color.clear
                            .shimmering()
                    }
                }
                else if let image = model.podcast?.artwork {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4, style: .continuous)
                } else {
                    Image("podcast")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4, style: .continuous)
                }
            }
    }
    
}
