//
//  AsyncImageManager.swift
//  FPT
//
//  Created by Hans Rietmann on 10/07/2021.
//

import Foundation
import SwiftUI



class AsyncImageManager: ObservableObject {
    
    
    private(set) var url: URL?
    @Published private(set) var image = ManagerState<Image>.waiting
    
    
    init(url: URL?) {
        self.url = url
        loadImage()
    }
    
    
    func load(url: URL) {
        self.url = url
        loadImage()
    }
    
    
    private func loadImage() {
        guard let imageURL = url else {
            DispatchQueue.main.async {
                self.image = .waiting
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
