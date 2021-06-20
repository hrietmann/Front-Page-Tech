//
//  ForumView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct ForumView: View {
    var body: some View {
        VStack(spacing: 0) {
            ForumHeader()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(Comment.list) { comment in
                        CommentView(comment: comment)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct ForumView_Previews: PreviewProvider {
    static var previews: some View {
        ForumView()
    }
}
