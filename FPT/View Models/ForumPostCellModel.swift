//
//  ForumPostCellModel.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth



@MainActor
class ForumPostCellModel: ObservableObject {
    
    
    @Published private(set) var post: ForumPost
    @Published private(set) var userVote: ForumPostVote?
    
    @Published private(set) var user: Authenticator.User? {
        didSet { listenForVotes() }
    }
    @Published private(set) var error: Error?
    @Published private(set) var isLoadingUser = false
    
    private var postListener: ListenerRegistration?
    private var userVoteListener: ListenerRegistration?
    
    
    init(post: ForumPost) {
        self.post = post
        loadUser()
        
        postListener = Firestore.firestore().collection("forum_posts")
            .document(post.id.uuidString)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let json = snapshot?.data(), let post = try? ForumPost.from(json: json) else { return }
                self?.post = post
        }
    }
    
    deinit {
        postListener?.remove()
        userVoteListener?.remove()
    }
    
    
    private func loadUser() {
        isLoadingUser = true
        error = nil
        userVoteListener?.remove()
        userVote = nil
        Task.detached {
            let result: Result<User?,Error>
            do { result = .success(try await User.with(id: self.post.userID)) }
            catch { result = .failure(error) }
            Task { @MainActor in
                self.isLoadingUser = false
                switch result {
                case .failure(let error): self.error = error
                case .success(let user): self.user = user
                }
            }
        }
    }
    
    
    private func listenForVotes() {
        guard let user = user else { return }
        userVoteListener = Firestore.firestore()
            .collection("forum_posts_votes")
            .whereField("userID", isEqualTo: user.id)
            .whereField("postID", isEqualTo: post.id.uuidString)
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, _ in
                let JSONs = snapshot?.documents.map({ $0.data() })
                let votes = try? JSONs?.map({ try ForumPostVote.from(json: $0) })
                self.userVote = votes?.first
            }
    }
    
    
}
