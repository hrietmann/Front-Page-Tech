//
//  PodcastsView.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import SwiftUI

struct PodcastsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Podcast.list) { podcast in
                    PodcastRow(podcast: podcast)
                }
            }
        }
        .navigationTitle(Text("Episodes"))
        .navigationBarHidden(false)
    }
}

struct PodcastsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastsView()
    }
}
