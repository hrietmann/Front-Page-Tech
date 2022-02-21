//
//  Podcast.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import Foundation
import FeedKit






struct PodcastEpisode: Identifiable {
    
    
    private let feedItem: RSSFeedItem
    
    let id: String
    var title: String? { feedItem.iTunes?.iTunesTitle ?? feedItem.title ?? feedItem.media?.mediaTitle?.value }
    var wrappedTitlte: String { title ?? "Genius Bar Episode" }
    var completeTitle: String { wrappedNumber + wrappedTitlte }
    var date: Date? { feedItem.pubDate }
    var number: Int? { feedItem.iTunes?.iTunesEpisode ?? Int(feedItem.title?.components(separatedBy: ":").first ?? "") }
    var wrappedNumber: String {
        if let number = number { return "\(number). " }
        return ""
    }
    var episodeNumber: String {
        if let number = number { return "Episode #\(number)" }
        return ""
    }
    var summary: String? { feedItem.iTunes?.iTunesSummary ?? video?.description }
    var htmlDescription: String? { feedItem.description }
    
    var duration: TimeInterval? { feedItem.iTunes?.iTunesDuration ?? 0 }
    var author: String? { feedItem.iTunes?.iTunesOwner?.name ?? feedItem.author ?? feedItem.dublinCore?.dcCreator }
    var authorEmail: String? { feedItem.iTunes?.iTunesOwner?.email }
    
    let audioURL: URL?
    let video: YoutubeEpisode?
    
    
    init(feedItem: RSSFeedItem, video: YoutubeEpisode?) {
        self.feedItem = feedItem
        self.video = video
        id = feedItem.guid?.value ?? video?.id ?? UUID().uuidString
        
        var audioLinks = [feedItem.enclosure?.attributes?.url]
        audioLinks.append(contentsOf: feedItem.media?.mediaContents?.map { $0.attributes?.url } ?? [])
        audioLinks.append(feedItem.media?.mediaEmbed?.attributes?.url)
        audioURL = audioLinks.lazy.compactMap { $0 }.compactMap { URL(string: $0) }.first
    }
    
    
}

//struct PodcastEpisode: Identifiable {
//    var id: String { title }
//    let title: String
//    let image: String
//    let date: Date
//    let description: String
//    let duration: TimeInterval
//
//
//    static let list = [
//        PodcastEpisode(title: "Jon Prosser RUINED WWDC...",
//                image: "Podcast 1", date: Date.string("09-06-2021"),
//                description: "Jon Prosser and Sam Kohl discuss WWDC 2021, including the non-existent M1X MacBook Pros, iOS and iPadOS 15, watchOS 8 and macOS 12 Monterey. These are our thoughts......",
//                duration: 1 * 60 * 60 + 26 * 60 + 21),
//
//        PodcastEpisode(title: "The iPad is F****d",
//                image: "Podcast 2",
//                date: Date.string("01-06-2021"),
//                description: "Jon Prosser and Sam Kohl are concerned about the state of the iPad ahead of WWDC next week. Plus, an intense argument about the way they each buy new products...",
//                duration: 1 * 60 * 60 + 54 * 60 + 2),
//
//        PodcastEpisode(title: "We got our new iMacs and we have THOUGHTS...",
//                image: "Podcast 3", date: Date.string("25-05-2021"),
//                description: "Genius Bar",
//                duration: 1 * 60 * 60 + 24 * 60 + 5),
//
//        PodcastEpisode(title: "Exclusive: Apple's SECRET PLAN for AirPods",
//                image: "Podcast 4", date: Date.string("18-05-2021"),
//                description: "Apple just announced lossless audio, but no AirPods support it...yet. Plus, Jon Prosser and Sam Kohl do a deep dive on Apple's ongoing court battle and more on this appointment at the Genius Bar.",
//                duration: 1 * 60 * 60 + 5 * 60 + 19),
//
//        PodcastEpisode(title: "The RETURN of the MacBook...",
//                image: "Podcast 5", date: Date.string("12-05-2021"),
//                description: "Jon Prosser and Sam Kohl react to a recent video about tech YouTubers and the state of YouTube as a whole...plus, more thoughts on the all new M1 iMac and a discussion about the return of the MacBook, MacBook.",
//                duration: 1 * 60 * 60 + 28 * 60 + 49),
//
//        PodcastEpisode(title: "Sam WRECKED His Tesla...",
//                image: "Podcast 6",
//                date: Date.string("04-05-2021"),
//                description: "Sam's week started off with quite the bang (he crashed his car)...and ended with some first impressions of AirTag. And Jon...well he has a myriad of interesting stories to share on this week's episode......",
//                duration: 1 * 60 * 60 + 16 * 60 + 8),
//
//        PodcastEpisode(title: "We changed our minds about the iMac...",
//                image: "Podcast 7", date: Date.string("26-04-2021"),
//                description: "Okay, okay... it's been about a week and we have slowly started to change our minds about how much we hate the new iMac redesign. We talk about that and more in this week's episode of Genius Bar!",
//                duration: 1 * 60 * 60 + 11 * 60 + 55),
//
//        PodcastEpisode(title: "This is NOT the iMac we wanted!",
//                image: "Podcast 8", date: Date.string("22-04-2021"),
//                description: "This week, Jon and Sam record just a few hours after the Apple April Event wraps up to give their full reaction and rundown of Apple's 'loaded' product drop!",
//                duration: 1 * 60 * 60 + 4 * 60 + 21),
//
//        PodcastEpisode(title: "BONUS EPISODE: The Apple April Event is official! Never doubt The Good Good.",
//                image: "Podcast 9", date: Date.string("14-04-2021"),
//                description: "We're back! Already, for our very first bonus episode! We are too excited. The Apple Event is official, Siri leaked it, and invites are now out! Here's what we think...",
//                duration: 36 * 60 + 13)
//    ]
//
//
//    init(
//        title: String,
//        image: String,
//        date: Date,
//        description: String,
//        duration: TimeInterval
//    ) {
//        self.title = title
//        self.image = image
//        self.date = date
//        self.description = description
//        self.duration = duration
//    }
//}
