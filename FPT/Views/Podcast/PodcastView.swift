//
//  PodcastView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import Shimmer
import AuthenticationKit
import ViewKit


struct PodcastView: View {
    
    @EnvironmentObject private var model: PodcastViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PodcastHeader()
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        PodcastCover()
                        twitters
                        Section(header: sectionHeader) {
                            LazyVStack(spacing: 0) {
                                if let episodes = model.podcast?.episodes {
                                    ForEach(episodes) { episode in
                                        PodcastRow(episode: episode)
                                    }
                                } else {
                                    ForEach(0...10, id: \.self) { _ in PodcastRow() }
                                }
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if let episode = model.playerState.episode
                    { PodcastBanner(episode: episode) }
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        .redacted(reason: model.isLoadingPodcast ? .placeholder : [])
        .shimmering(active: model.isLoadingPodcast)
        .disabled(model.isLoadingPodcast)
        .sheet(item: $model.presentedEpisode) { episode in
            PodcastEpisodeView(episode: episode)
        }
    }
    
    var twitters: some View {
        VStack(alignment: .leading) {
            Text("Follow us on social media".uppercased())
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    CapsuleLink(icon: "twitter", title: "Genius Bar", destination: URL(string: "https://twitter.com/geniusbarcast")!)
                        .foregroundColor(Color("twitter"))
                    CapsuleLink(icon: "youtube", title: "Sam", destination: URL(string: "https://www.youtube.com/iupdate")!)
                    CapsuleLink(icon: "youtube", title: "Jon", destination: URL(string: "https://www.youtube.com/user/frontpagetech")!)
                    CapsuleLink(icon: "twitter", title: "Sam", destination: URL(string: "http://twitter.com/iupdate")!)
                        .foregroundColor(Color("twitter"))
                    CapsuleLink(icon: "twitter", title: "Jon", destination: URL(string: "http://twitter.com/jon_prosser")!)
                        .foregroundColor(Color("twitter"))
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
            }
            .padding(.bottom, 8)
            Divider()
        }
        .padding(.top, 8)
        .background(Color(.systemGroupedBackground))
        .padding(.bottom)
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
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
