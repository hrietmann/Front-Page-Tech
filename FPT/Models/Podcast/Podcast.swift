//
//  Podcast.swift
//  FPT
//
//  Created by Hans Rietmann on 09/02/2022.
//

import SwiftUI
import FeedKit





struct Podcast {
    
    private let itunes: iTunesResult
    private let podcastRSS: RSSFeed
    private let youtubeFeed: YoutubeFeed
    
    let artwork: UIImage
    let colors: ImageColors
    
    var name: String { podcastRSS.title ?? itunes.trackName }
    var author: String { podcastRSS.iTunes?.iTunesAuthor ?? itunes.artistName }
    var description: String { podcastRSS.description ?? podcastRSS.iTunes?.iTunesSummary ?? "" }
    var genre: String { podcastRSS.iTunes?.iTunesCategories?.first?.attributes?.text ?? itunes.genres.first ?? "Tech" }
    var itunesURL: URL { itunes.trackViewUrl }
    let episodes: [PodcastEpisode]
    
    init(itunes: iTunesResult, podcastRSS: RSSFeed, artwork: UIImage, colors: ImageColors, youtubeFeed: YoutubeFeed) {
        self.itunes = itunes
        self.podcastRSS = podcastRSS
        self.artwork = artwork
        self.colors = colors
        self.youtubeFeed = youtubeFeed
        episodes = podcastRSS.items?.map { item in
            let video = youtubeFeed.episode(for: item)
            return PodcastEpisode(feedItem: item, video: video)
        } ?? []
    }
}
