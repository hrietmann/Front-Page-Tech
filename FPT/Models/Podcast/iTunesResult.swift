//
//  iTunesResult.swift
//  FPT
//
//  Created by Hans Rietmann on 09/02/2022.
//

import Foundation



struct iTunesResult: Codable {
    let trackName: String
    let artistName: String
    let feedUrl: URL
    let trackViewUrl: URL
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl100: URL
    let artworkUrl600: URL
    let country: String
    let trackCount: Int
    let releaseDate: Date
    let primaryGenreName: String
    let genreIds: [String]
    let genres: [String]
}
