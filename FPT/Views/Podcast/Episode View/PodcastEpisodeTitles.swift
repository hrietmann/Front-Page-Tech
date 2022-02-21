//
//  PodcastEpisodeTitles.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeTitles: View {
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                Text(podcast.presentedEpisode?.title ?? "Episode title")
                    .font(.title2, weight: .heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding(.horizontal, 16 * 2)
            }
            .overlay {
                HStack {
                    LinearGradient(colors: [.systemBackground.opacity(1), .systemBackground.opacity(0)], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 16 * 2)
                        .frame(maxHeight: .infinity)
                    Spacer()
                    LinearGradient(colors: [.systemBackground.opacity(1), .systemBackground.opacity(0)], startPoint: .trailing, endPoint: .leading)
                        .frame(width: 16 * 2)
                        .frame(maxHeight: .infinity)
                }
            }
            Text("\(podcast.podcast?.name ?? "Podcast name") — Episode #\(podcast.presentedEpisode?.number ?? 0)")
                .font(.subheadline, weight: .bold)
                .foregroundColor(.secondary)
                .padding(.leading, 16 * 2)
        }
    }
}

struct PodcastEpisodeTitles_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeTitles()
    }
}
