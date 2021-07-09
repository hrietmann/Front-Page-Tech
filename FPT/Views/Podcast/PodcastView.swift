//
//  PodcastView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct PodcastView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PodcastHeader()
                ScrollView(showsIndicators: false) {
                    PodcastCover()
                    VStack(spacing: 0) {
                        Section(header: sectionHeader) {
                            LazyVStack(spacing: 0) {
                                ForEach(Podcast.list) { podcast in
                                    PodcastRow(podcast: podcast)
                                }
                            }
                        }

                    }
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    var sectionHeader: some View {
        VStack {
            HStack {
                Text("Episodes".uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: PodcastsView()) {
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
    }
}

struct PodcastView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastView()
    }
}
