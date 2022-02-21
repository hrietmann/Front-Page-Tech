//
//  YoutubeFeed.swift
//  FPT
//
//  Created by Hans Rietmann on 10/02/2022.
//

import Foundation
import SWXMLHash
import FeedKit



struct YoutubeFeed {
    private let episodes: [YoutubeEpisode]
    
    init(data: Data) throws {
        episodes = try XMLHash.parse(data)["feed"]["entry"]
            .all.map { try .init(entry: $0) }
    }
    
    func episode(for episode: RSSFeedItem) -> YoutubeEpisode? {
        
        struct CharacterMatcher {
            let matchingRatio: Double
            let errorRatio: Double
            let levenshteinDistanceScore: Double
            let macthingFirstThreeWord: Bool
            let episode: YoutubeEpisode
            
            init(episode: YoutubeEpisode, title: String) {
                var titleFormatted = title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                var epTitleFormatted = episode.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                var total = 0
                var matches = 0
                var errors = 0
                for character in titleFormatted {
                    defer {
                        titleFormatted.removeFirst()
                        total += 1
                    }
                    if let sameCharIndex = epTitleFormatted.firstIndex(of: character) {
                        matches += 1
                        epTitleFormatted.remove(at: sameCharIndex)
                    } else { errors += 1 }
                }
                
                matchingRatio = Double(matches) / Double(total)
                errorRatio = Double(errors) / Double(total)
                levenshteinDistanceScore = episode.title.levenshteinDistanceScore(to: title, ignoreCase: true, trimWhiteSpacesAndNewLines: true)
                
                let titleWords = title.components(separatedBy: " ").filter { $0 != "" }.map { $0.lowercased() }
                let epTitleWords = episode.title.components(separatedBy: " ").filter { $0 != "" }.map { $0.lowercased() }
                if titleWords.count >= 3, epTitleWords.count >= 3 {
                    macthingFirstThreeWord =
                    titleWords[0] == epTitleWords[0] &&
                    titleWords[1] == epTitleWords[1] &&
                    titleWords[2] == epTitleWords[2]
                } else  { macthingFirstThreeWord = false }
                self.episode = episode
            }
        }
        
        if let title = episode.iTunes?.iTunesTitle ?? episode.title {
            let episode = self.episodes.lazy
                .map { CharacterMatcher(episode: $0, title: title) }
//                .filter { $0.matchingRatio > 0.95 && $0.errorRatio < 0.05 }
//                .sorted(by: { $0.matchingRatio >= $1.matchingRatio })
                .filter {
                    if let number = episode.iTunes?.iTunesEpisode ??
                        Int(episode.title?.components(separatedBy: ":").first ?? ""),
                       $0.episode.title.contains("\(number)") {
                        return true
                    }
                    return $0.levenshteinDistanceScore >= 4 && $0.macthingFirstThreeWord
                }
                .sorted(by: { $0.levenshteinDistanceScore >= $1.levenshteinDistanceScore })
                .first?.episode
            if let episode = episode { return episode }
        }
        
        if let number = episode.iTunes?.iTunesEpisode {
            return episodes.first(where: { $0.title.contains("\(number)") })
        }
        return nil
    }
}


extension String {
    func levenshteinDistanceScore(to string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Double {
        
        var firstString = self
        var secondString = string
        
        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)
        
        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        
        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)
        
        if let validDistance = last.last {
            return  1 - (Double(validDistance) / Double(lowestScore))
        }
        
        return 0.0
    }
}
