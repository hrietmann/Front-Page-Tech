//
//  ForumPostMessageMissing.swift
//  FPT
//
//  Created by Hans Rietmann on 03/02/2022.
//

import Foundation




struct ForumPostMessageMissing: LocalizedError {
    var errorDescription: String? { "Don't you forgot something? Yeah, there's nothing in this post. I can't create a post without any message in it." }
}
