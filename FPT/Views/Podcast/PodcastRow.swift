//
//  PodcastRow.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct PodcastRow: View {
    
    let podcast: Podcast
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(podcast.date.timeAgo.uppercased())
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundColor(.secondary)
                    Text(podcast.title)
                        .font(.headline)
                        .bold()
                    Text(podcast.description)
                        .font(.footnote)
                        .foregroundColor(Color(.tertiaryLabel))
                    Text(podcast.duration.duration)
                        .font(.footnote)
                        .foregroundColor(.pink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {}) {
                    Image(systemName: "play.fill")
                        .font(Font.footnote.bold())
                        .foregroundColor(.pink)
                        .padding(12)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(Circle())
                }
            }
            .padding(.trailing)
            Divider()
        }
        .padding(.leading)
        .padding(.top)
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow(podcast: .list[0])
    }
}
