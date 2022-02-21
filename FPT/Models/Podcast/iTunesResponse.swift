//
//  iTunesResponse.swift
//  FPT
//
//  Created by Hans Rietmann on 09/02/2022.
//

import Foundation



struct iTunesResponse: Codable {
    let resultCount: Int
    let results: [iTunesResult]
}
