//
//  PodcastView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct PodcastView: View {
    var body: some View {
        VStack(spacing: 0) {
            PodcastHeader()
            ScrollView(showsIndicators: false) {
                PodcastCover()
                VStack(spacing: 0) {
                    Section(header: {
                        VStack {
                            HStack {
                                Text("Episodes".uppercased())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: {}) {
                                    Text("See all")
                                        .bold()
                                        .foregroundColor(.pink)
                                }
                            }
                            .padding(.trailing)
                            Divider()
                        }
                        .padding(.leading)
                        .padding(.top)
                    }()) {
                        LazyVStack(spacing: 0) {
                            ForEach(Podcast.list) { podcast in
                                PodcastRow(podcast: podcast)
                            }
                        }
                    }

                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
    }
}
