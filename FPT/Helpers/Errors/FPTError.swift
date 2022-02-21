//
//  Error.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation



struct FPTError: LocalizedError, Equatable {
    
    private var reason: String
    var errorDescription: String? { reason }
    var failureReason: String? { reason }
    
    init(custom reason: String) {
        self.reason = reason
    }
    init(error: Swift.Error) {
        self.reason = error.localizedDescription
    }
    
    
    static func incorrectURL(link: String) -> FPTError {
            .init(custom: "You did get thrown to the 🚽… The URL used to load those data is incorrect (\(link)).")
    }
    
    static func noRSSFeedFound(for link: String) -> FPTError {
            .init(custom: "Huston I think we have a problem here… We didn't found the RSS feed on FAH PAH TAH DOT COM ! 🧻")
    }
    
    static func noItemsFound(in feed: NewsFeedManager.Feed) -> FPTError {
            .init(custom: "Umh… Sorry there's nothing here. Maybe you should take a look somewhere else. Please ?\nBecause if you stay here, it's going to be embarrassing… 😳")
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.reason == rhs.reason }
    
}


extension Swift.Error {
    var local: FPTError { .init(error: self) }
}
