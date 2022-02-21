//
//  PodcastEpisodeDescription.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeDescription: View {
    
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    
    var body: some View {
        if let description = episode.episode.video?.description ?? episode.episode.summary {
            VStack(alignment: .leading, spacing: 16) {
                Text("Description".uppercased())
                    .font(.title3, weight: .heavy)
                Divider()
                    .padding(.bottom, 16)
                Text(description)
                    .font(.headline, weight: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(16 * 2)
            .background(.systemGroupedBackground)
        } else { EmptyView() }
    }
}

struct PodcastEpisodeDescription_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeDescription()
    }
}
