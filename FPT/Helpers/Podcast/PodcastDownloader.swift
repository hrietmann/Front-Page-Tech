//
//  File.swift
//  FPT
//
//  Created by Hans Rietmann on 12/02/2022.
//

import SwiftUI
import CodableKit
import FeedKit
import SWXMLHash


struct PodcastDownloader {
    
    let itunesPodcastID: String
    let youtubeChannelID: String
    
    init(itunesPodcastID: String = "1550568878", youtubeChannelID: String = "UCWWFDm96ZEnlIStstBgHF_A") {
        self.itunesPodcastID = itunesPodcastID
        self.youtubeChannelID = youtubeChannelID
    }
    
    var podcast: Podcast {
        get async throws {
            async let youtubeTask = self.youtube
            async let podcastTask = self.podcastContent
            let (youtube, podcastContent) = try await (youtubeTask, podcastTask)
            return Podcast(
                itunes: podcastContent.itunes,
                podcastRSS: podcastContent.feed,
                artwork: podcastContent.artwork,
                colors: podcastContent.colors,
                youtubeFeed: youtube
            )
        }
    }
    
    private var itunes: iTunesResult {
        get async throws {
            let url = URL(string: "https://itunes.apple.com/lookup?id=\(itunesPodcastID)&entity=podcast")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (data, response) = try await URLSession.shared.data(for: request)
            if let response = response as? HTTPURLResponse, response.statusCode != 200
            { throw FPTError(custom: "Something went wrong with iTunes.. 🙄") }
            guard let itunes = try iTunesResponse.from(data: data).results.first
            else { throw FPTError(custom: "Unable to find the Podcast on iTunes. Is it still up there?.. Who knows.. 😓") }
            return itunes
        }
    }
    
    
    private func podcastFeed(from itunes: iTunesResult) async throws -> RSSFeed {
        let feed = try await self.feed(from: itunes.feedUrl).rssFeed
        guard let feed = feed else { throw FPTError(custom: "Podcast feed not found.") }
        return feed
    }
    
    
    private func artwork(of feed: RSSFeed, from itunes: iTunesResult) async throws -> UIImage {
        let artworkLink = feed.image?.url ?? itunes.artworkUrl600.absoluteString
        guard let artworkURL = URL(string: artworkLink) else { throw FPTError(custom: "Inavlid artwork url (\(artworkLink)).") }
        let (data, response) = try await URLSession.shared.data(from: artworkURL)
        if let response = response as? HTTPURLResponse, response.statusCode != 200
        { throw FPTError(custom: "Something went wrong with podcast artwork download.. 🙄") }
        guard let artwork = UIImage(data: data)
        else { throw FPTError(custom: "Unable to decode artwork data to the image.") }
        return artwork
    }
    
    
    private var podcastContent: (itunes: iTunesResult, feed: RSSFeed, artwork: UIImage, colors: ImageColors) {
        get async throws {
            let itunes = try await self.itunes
            let feed = try await podcastFeed(from: itunes)
            let artwork = try await artwork(of: feed, from: itunes)
            let colors = await artwork.colors
            return (itunes: itunes, feed: feed, artwork: artwork, colors: colors)
        }
    }
    
    
    private func feed(from url: URL) async throws -> Feed {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse, response.statusCode != 200
        { throw FPTError(custom: "Something went wrong with a RSS feed.. 🙄\n(at url '\(url.absoluteString)')") }
        return try feed(from: data)
    }
    
    
    private func feed(from data: Data) throws -> Feed {
        let feedResult = FeedParser(data: data).parse()
        switch feedResult {
        case .failure(let error):
            let serverError = "We have a plumbing problem on our side... Please, give us some time to figure it out! 🚽🔧"
            let message: String
            switch error {
            case .feedNotFound: message = serverError + "(Feed not found)"
            case .feedCDATABlockEncodingError(let path): message = serverError + "\n(Feed data key error at path '\(path)')"
            case .internalError(let reason):  message = serverError + "\n(\(reason))"
            }
            throw FPTError(custom: message)
            
        case .success(let feed): return feed
        }
    }
    
    
    private var youtube: YoutubeFeed {
        get async throws {
            let url = URL(string: "https://www.youtube.com/feeds/videos.xml?channel_id=\(youtubeChannelID)")!
            let (data, response) = try await URLSession.shared.data(from: url)
            if let response = response as? HTTPURLResponse, response.statusCode != 200
            { throw FPTError(custom: "Something went wrong with a RSS feed.. 🙄\n(Received \(response.statusCode) from '\(url.absoluteString)')") }
            return try .init(data: data)
        }
    }
    
}
