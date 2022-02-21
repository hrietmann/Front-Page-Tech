//
//  Networker.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation
import AVFoundation




class Networker {
    
    
    private let link: String
    
    
    init(link: String) {
        self.link = link
    }
    
    func request<Result:Codable>(_ result: Result.Type, _ completion: @escaping (Swift.Result<Result, FPTError>) -> ()) {
        guard let url = URL(string: link) else { completion(.failure(.incorrectURL(link: link))) ; return }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error.local))
                    return
                }
                guard let data = data else { return }
                do { completion(.success(try JSONDecoder().decode(result, from: data))) }
                catch { completion(.failure(error.local)) }
            }
        }
        session.resume()
    }
    
    
}
