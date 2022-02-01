//
//  Error.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation



struct Error: LocalizedError {
    
    private var reason: String
    var errorDescription: String? { reason }
    var failureReason: String? { reason }
    
    init(custom reason: String) {
        self.reason = reason
    }
    init(error: Swift.Error) {
        self.reason = error.localizedDescription
    }
    
    
    static func incorrectURL(link: String) -> Error {
            .init(custom: "You did get thrown to the 🚽… The URL used to load those data is incorrect (\(link)).")
    }
    
    static func noRSSFeedFound(for link: String) -> Error {
            .init(custom: "Huston I think we have a problem here… We didn't found the RSS feed on FAH PAH TAH DOT COM ! 🧻")
    }
    
    static func noItemsFound(in feed: NewsFeedManager.Feed) -> Error {
            .init(custom: "Umh… Sorry there's nothing here. Maybe you should take a look somewhere else. Please ?\nBecause if you stay here, it's going to be embarrassing… 😳")
    }
    
}


extension Swift.Error {
    var local: Error { .init(error: self) }
}
