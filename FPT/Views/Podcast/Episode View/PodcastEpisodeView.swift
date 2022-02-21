//
//  PodcastEpisodeView.swift
//  FPT
//
//  Created by Hans Rietmann on 09/02/2022.
//

import SwiftUI
import SwiftUIX
import Shimmer
import ViewKit
import AVKit
import YouTubePlayerKit



struct PodcastEpisodeView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject private var model: PodcastViewModel
    @StateObject private var episodeModel: PodcastEpisodeViewModel
    @State private var presentError = false
    
    
    init(episode: PodcastEpisode) {
        let model = PodcastEpisodeViewModel(episode: episode)
        _episodeModel = StateObject(wrappedValue: model)
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                PodcastEpisodeHeader()
                PodcastEpisodeTimeline()
                PodcastEpisodeTitles()
                PodcastEpisodeControls()
                PodcastEpisodeVolumeSlider()
                PodcastEpisodeContentActions()
                Divider()
                PodcastEpisodeDescription()
            }
        }
        .environmentObject(episodeModel)
        .alert("Error", isPresented: $presentError) {
            Button("Dismiss", action: dismiss.callAsFunction)
        } message: {
            Text(model.playError?.localizedDescription ?? "An error happened.")
        }
        .onAppear {
            if model.playerState.isIdle { playEpisode() ; return }
            if model.playerState.episode?.id != episodeModel.episode.id { playEpisode() ; return }
        }
    }
    
    private func playEpisode() {
        model.play(episode: episodeModel.episode)
    }
}
