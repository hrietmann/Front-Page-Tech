//
//  ForumPost.swift
//  FPT
//
//  Created by Hans Rietmann on 02/02/2022.
//

import Foundation




struct ForumPost: Codable, Identifiable {
    
    let id: UUID
    let parentID: UUID?
    let isDiscussionRoot: Bool
    let userID: String
    let date: Date
    let message: String
    let upVotes: Int
    let downVotes: Int
    let views: Int
    let comments: Int
    
    init(message: String, from user: User, respondingTo post: ForumPost? = nil) {
        id = UUID()
        parentID = post?.id
        isDiscussionRoot = post?.id == nil
        userID = user.id
        date = Date()
        self.message = message
        upVotes = 0
        downVotes = 0
        views = 0
        comments = 0
    }
    
    static var exemple: ForumPost {
        .init(id: UUID(), parentID: nil, userID: "H8Nk0nCam6ffG4RenFEVxdGUTmc2", date: Date(), message: "Message from someone here. With some details. Maybe.", upVotes: 24, downVotes: 2, views: 5_123, comments: 0)
    }
    private init(
        id: UUID,
        parentID: UUID?,
        userID: String,
        date: Date,
        message: String,
        upVotes: Int,
        downVotes: Int,
        views: Int,
        comments: Int
    ) {
        self.id = id
        self.parentID = parentID
        isDiscussionRoot = parentID == nil
        self.userID = userID
        self.date = date
        self.message = message
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.views = views
        self.comments = comments
    }
    
}
