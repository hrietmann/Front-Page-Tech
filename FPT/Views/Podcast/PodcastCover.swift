//
//  PodcastCover.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit


struct PodcastCover: View {
    
    @State private var presentNotWorking = false
    @EnvironmentObject private var model: PodcastViewModel
     
    var body: some View {
        VStack(spacing: 16) {
            
            Color(uiColor: .tertiarySystemFill)
                .frame(width: UIScreen.main.bounds.width * 0.6,
                       height: UIScreen.main.bounds.width * 0.6)
                .overlay {
                    if let image = model.podcast?.artwork {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 16)
            
            Text(model.podcast?.name.uppercased() ?? "PODCAST NAME")
                .font(.title3.weight(.heavy))
                .foregroundColor(Color.white)
            
            Text(model.podcast?.author ?? "Podcast author")
                .font(.footnote)
                .foregroundColor(model.podcast?.colors.primary ?? Color.secondary)
            
            Button {
                switch model.playerState {
                case .playing(let episode): model.pause(episode: episode)
                case .paused(let episode): model.play(episode: episode)
                case .idle:
                    guard let first = model.podcast?.episodes.first else { return }
                    model.presentedEpisode = first
                }
            } label: {
                Label(model.playerState.isPlaying ? "Pause": "Play", systemImage: model.playerState.isPlaying ? "pause.fill": "play.fill")
                    .padding(.vertical)
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.black)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.bounce)
            
            Text(model.podcast?.description ?? "Podcast description")
                .font(.footnote)
                .foregroundColor(Color.white)
            
            Text("\(model.podcast?.genre ?? "Genre") • Updates each week")
                .font(.footnote)
                .foregroundColor(model.podcast?.colors.primary ?? Color.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity)
        .background(model.podcast?.colors.background ?? Color(uiColor: .tertiarySystemFill))
        .buttonStyle(BounceButtonStyle())
        .overlay(
            (model.podcast?.colors.background ?? Color(uiColor: .tertiarySystemFill))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .padding(.top, -UIScreen.main.bounds.width)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
    }
}

struct PodcastCover_Previews: PreviewProvider {
    static var previews: some View {
        PodcastCover()
            .environmentObject(PodcastViewModel())
    }
}
