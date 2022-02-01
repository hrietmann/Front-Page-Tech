//
//  ArticleManager.swift
//  FPT
//
//  Created by Hans Rietmann on 28/06/2021.
//

import Foundation
import SwiftUI
import FeedKit
import SwiftSoup





class ArticleManager: ObservableObject {
    
    
    private let feedItem: RSSFeedItem?
    @Published private(set) var image = ManagerState<Image>.waiting
    @Published private(set) var article = ManagerState<Article>.waiting
    
    
    init(feed item: RSSFeedItem?) {
        self.feedItem = item
        loadHTML()
    }
    
    
    
    private func loadHTML() {
        guard let feedItem = feedItem else {
            return
        }

        image = .loading
        article = .loading
        let pageLink = feedItem.id
        guard let pageURL = URL(string: pageLink) else {
            let error = Error.incorrectURL(link: pageLink)
            image = .failure(error: error)
            article = .failure(error: error)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let request = URLRequest(url: pageURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30*60)
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.image = .failure(error: error.local)
                        self.article = .failure(error: error.local)
                    }
                    return
                }
                guard let data = data else { return }
                guard let html = String(data: data, encoding: .ascii) else { fatalError() }
                do {
                    guard let feedItem = self.feedItem else {
                        return
                    }

                    let article = try Article(from: html, of: feedItem)
                    DispatchQueue.main.async {
                        self.article = .success(result: article)
                    }
                    self.loadImage(of: article)
                }
                catch {
                    DispatchQueue.main.async {
                        self.image = .failure(error: error.local)
                        self.article = .failure(error: error.local)
                    }
                }
            }
            session.resume()
        }
    }
    
    
    private func loadImage(of article: Article) {
        guard let imageURL = article.imageURL else {
            DispatchQueue.main.async {
                let link = article.imageURL?.absoluteString ?? "none found"
                let error = Error.incorrectURL(link: link)
                self.image = .failure(error: error)
            }
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 2*24*60*60)
        if let cachedData = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedData.data) {
            print("Image loaded from Cache 💾")
            DispatchQueue.main.async {
                self.image = .success(result: Image(uiImage: image))
            }
            return
        }
        
        let session = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.image = .failure(error: error.local)
                }
                return
            }
            guard let data = data,
                    let response = response,
                    let image = UIImage(data: data),
                  let compressed = image.jpegData(compressionQuality: 0.6),
                  let compressedImage = UIImage(data: compressed)
            else { return }
            let cacheData = CachedURLResponse(response: response, data: compressed)
            cache.storeCachedResponse(cacheData, for: request)
            print("Image loaded from internet ☁️")
            DispatchQueue.main.async {
                self.image = .success(result: Image(uiImage: compressedImage))
            }
        }
        session.resume()
    }
    
    
}
