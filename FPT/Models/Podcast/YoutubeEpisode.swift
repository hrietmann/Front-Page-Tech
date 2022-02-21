//
//  YoutubeEpisode.swift
//  FPT
//
//  Created by Hans Rietmann on 10/02/2022.
//

import Foundation
import SWXMLHash



struct YoutubeEpisode {
    
    
    let id: String
    let videoID: String
    let channelID: String
    let title: String
    let channelURL: URL
    let channelName: String
    let publication: Date
    let update: Date
    let videoURL: URL
    let thumbnailURL: URL
    let description: String
    let likes: Int
    let average: Double
    let views: Int
    
    
    init(entry: XMLIndexer) throws {
        id = try entry["id"].value()
        videoID = try entry["yt:videoId"].value()
        channelID = try entry["yt:channelId"].value()
        title = try entry["title"].value()
        channelURL = try entry["link"].value(ofAttribute: "href")
        channelName = try entry["author"]["name"].value()
        publication = try entry["published"].value()
        update = try entry["updated"].value()
        
        let group = entry["media:group"]
        videoURL = try group["media:content"].value(ofAttribute: "url")
        thumbnailURL = try group["media:thumbnail"].value(ofAttribute: "url")
        description = try group["media:description"].value()
        
        let community = group["media:community"]
        likes = try community["media:starRating"].value(ofAttribute: "count")
        average = try community["media:starRating"].value(ofAttribute: "average")
        views = try community["media:statistics"].value(ofAttribute: "views")
    }
    
    
}
