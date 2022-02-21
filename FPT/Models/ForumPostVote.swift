//
//  ForumPostVote.swift
//  FPT
//
//  Created by Hans Rietmann on 08/02/2022.
//

import Foundation



struct ForumPostVote: Codable, Identifiable {
    
    let id: UUID
    let date: Date
    let userID: String
    let postID: UUID
    let isUp: Bool
    
}
