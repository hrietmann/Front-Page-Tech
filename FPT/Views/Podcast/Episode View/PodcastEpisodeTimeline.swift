//
//  PodcastEpisodeTimeline.swift
//  FPT
//
//  Created by Hans Rietmann on 15/02/2022.
//

import SwiftUI

struct PodcastEpisodeTimeline: View {
    
    @EnvironmentObject private var podcast: PodcastViewModel
    @EnvironmentObject private var episode: PodcastEpisodeViewModel
    
    var body: some View {
        VStack(spacing: 6) {
            slider
                .accentColor(Color(uiColor: .systemGray2))
                .frame(maxWidth: .infinity)
                .frame(height: 4)
            HStack {
                Text(comps(for: episode.elapsedTime))
                Spacer()
                Text(comps(for: episode.timeLeft))
            }
            .foregroundColor(.tertiaryLabel)
            .font(.subheadline, weight: .bold)
        }
        .padding(.horizontal, 16 * 2)
        .padding(.bottom, 16 * 2)
        .onReceive(podcast.$playingEpisodeElapsedTime) { elapsedTime in
            if podcast.playerState.episode?.id == episode.episode.id
            { episode.elapsedTime = elapsedTime }
        }
    }
    
    var duration: Double { episode.episode.duration ?? 0 }
    var ratio: Double { episode.elapsedTime / duration }
    
    var slider: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.systemGray5)
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * CGFloat(ratio))
            }
            .cornerRadius(12)
            .overlay {
                Circle()
                    .frame(width: geometry.size.height * 3, height: geometry.size.height * 3)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: (geometry.size.width * CGFloat(ratio)) - (geometry.size.height * 3) / 2)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let ratio = min(max(0, Double(value.location.x / geometry.size.width)), 1)
                        let elapsedTime = min(max(0, ratio * duration), duration)
                        episode.elapsedTime = elapsedTime
                    }
                    .onEnded { _ in
                        podcast.set(elapsedTime: episode.elapsedTime)
                    }
            )
        }
    }
    
    func comps(for duration: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.allowsFractionalUnits = false
        return formatter.string(from: duration.isFinite ? duration:0) ?? ""
    }
}

struct PodcastEpisodeTimeline_Previews: PreviewProvider {
    static var previews: some View {
        PodcastEpisodeTimeline()
    }
}
