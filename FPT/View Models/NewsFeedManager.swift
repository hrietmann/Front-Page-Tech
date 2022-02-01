//
//  ExclusivesViewManager.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation
import FeedKit




class NewsFeedManager: ObservableObject {
    
    
    enum Feed: String {
        case today
        case exclusives
        case apple
        case android
        case videos
        
        var link: String {
            switch self {
            case .today: return "https://www.frontpagetech.com/feed/"
            default: return "https://www.frontpagetech.com/category/\(rawValue)/feed/"
            }
        }
    }
    
    
    let feed: Feed
    @Published private(set) var state = ManagerState<[RSSFeedItem]>.waiting
    
    
    init(feed: Feed) {
        self.feed = feed
        load()
    }
    
    
    func load() {
        state = .loading
        guard let url = URL(string: feed.link) else {
            state = .failure(error: .incorrectURL(link: feed.link))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let request = URLRequest(url: url)
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.state = .failure(error: error.local)
                        return
                    }
                    guard let data = data else { return }
                    let parser = FeedParser(data: data)
                    let result = parser.parse()
                    self.handle(result)
                }
            }
            session.resume()
        }
    }
    
    private func handle(_ result: Result<FeedKit.Feed, ParserError>) {
        switch result {
        case .failure(let error):
            let serverError = "We have a plumbing problem on our side... Please, give us some time to figure it out! 🚽🔧"
            let message: String
            switch error {
            case .feedNotFound:
                message = serverError + "(Feed not found)"
                
            case .feedCDATABlockEncodingError(let path):
                message = serverError + "\n(Feed data key error at path '\(path)')"
                
            case .internalError(let reason):
                message = serverError + "\n(\(reason))"
            }
            self.state = .failure(error: Error(custom: message))
        case .success(let feed):
            guard let rss = feed.rssFeed else {
                self.state = .failure(error: .noRSSFeedFound(for: self.feed.link))
                return
            }
            guard let items = rss.items else {
                self.state = .failure(error: .noItemsFound(in: self.feed))
                return
            }
            self.state = .success(result: items)
        }
    }
    
    
}



extension RSSFeedItem: Identifiable {
    public var id: String { guid?.value ?? link ?? UUID().uuidString }
}
