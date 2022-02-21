//
//  PodcastEpisodeVolumeSlider.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeVolumeSlider: View {
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "speaker.fill")
            Slider(value: $podcast.volume)
            Image(systemName: "speaker.wave.3.fill")
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
        .tint(.secondary)
        .padding(.horizontal, 16 * 2)
        .padding(.bottom, 16 * 2)
    }
}

struct PodcastEpisodeVolumeSlider_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeVolumeSlider()
    }
}
