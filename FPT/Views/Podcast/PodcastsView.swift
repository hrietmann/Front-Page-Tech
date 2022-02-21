//
//  PodcastsView.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import SwiftUI
import Shimmer

struct PodcastsView: View {
    
    @EnvironmentObject private var model: PodcastViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                if let episodes = model.podcast?.episodes {
                    ForEach(episodes) { episode in
                        PodcastRow(episode: episode)
                    }
                } else {
                    ForEach(0...20, id: \.self) { _ in
                        PodcastRow()
                    }
                }
            }
        }
        .navigationTitle(Text("Episodes"))
        .navigationBarHidden(false)
        .shimmering(active: model.isLoadingPodcast)
        .disabled(model.isLoadingPodcast)
    }
}

struct PodcastsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastsView()
            .environmentObject(PodcastViewModel())
    }
}
