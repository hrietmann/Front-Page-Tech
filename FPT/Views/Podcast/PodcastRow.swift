//
//  PodcastRow.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit

struct PodcastRow: View {
    
    let podcast: Podcast
    @State private var presentNotWorkedFeature = false
    
    var body: some View {
        VStack(spacing: 16) {
            thumbnail
            
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
                
                Button(action: { presentNotWorkedFeature.toggle() }) {
                    Image(systemName: "headphones")
                        .font(Font.caption.bold())
                        .foregroundColor(.pink)
                        .padding(8)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(Circle())
                }
                .alert(isPresented: $presentNotWorkedFeature) {
                    Alert(title: Text("Just visual…"), message: Text("…for now. Honestly, I didn't work much more than on visuals for the podcasts section. However there's a lot to be done, so stay tuned !"), dismissButton: .cancel(Text("Keep it up 👍🏼")))
                }
            }
            .padding(.trailing)
            Divider()
        }
        .padding(.leading)
        .padding(.top)
    }
    
    @State private var isAppeared = false
    var thumbnail: some View {
        Image(podcast.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onAppear(perform: {
                withAnimation(.spring().delay(2.4)) {
                    isAppeared = true
                }
            })
            .onDisappear(perform: { isAppeared = false })
            .overlay(
                Color.black
                    .opacity(isAppeared ? 0.3:0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .overlay(
                Button(action: { presentNotWorkedFeature.toggle() }, label: {
                Image(systemName: "play.fill")
                    .font(Font.footnote.bold())
                    .foregroundColor(.pink)
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .opacity(isAppeared ? 1:0)
                    .offset(y: isAppeared ? 0:32)
            })
                    .buttonStyle(BounceButtonStyle())
            )
            .cornerRadius(8)
            .padding(.trailing)
    }
}

struct PodcastRow_Previews: PreviewProvider {
    static var previews: some View {
        PodcastRow(podcast: .list[0])
    }
}
