//
//  ForumPostViewModel.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth



@MainActor
class ForumPostViewModel: ObservableObject {
    
    
    @Published private(set) var post: ForumPost
    
    @Published private(set) var user: Authenticator.User? {
        didSet { listenForVotes() }
    }
    @Published private(set) var isLoadingUser = false
    @Published var userError: Error?
    
    @Published private(set) var userVote: ForumPostVote?
    @Published private(set) var isLoadingVote = false
    @Published var voteError: Error?
    private var userVoteListener: ListenerRegistration?
    
    @Published private(set) var posts = [ForumPost]()
    @Published private(set) var isLoadingPosts = false
    @Published var postsError: Error?
    private var postListener: ListenerRegistration?
    private var postsListener: ListenerRegistration?
    private let postsCollectionRef = Firestore.firestore().collection("forum_posts")
    private var postReference: DocumentReference { postsCollectionRef.document(post.id.uuidString) }
    private var postsReference: Query {
        postsCollectionRef.whereField("parentID", isEqualTo: self.post.id.uuidString).order(by: "date", descending: true)
    }
    
    @Published var commentEntry = ""
    @Published private(set) var isSendingComment = false
    @Published var commentError: Error?
    
    @Published private(set) var isDeletingPost = false
    @Published var deletionError: Error?
    @Published private(set) var isDeleted = false
    
    
    init(post: ForumPost) {
        self.post = post
        loadUser()
        
        postListener = postReference.addSnapshotListener { [weak self] snapshot, _ in
            guard let json = snapshot?.data(), let post = try? ForumPost.from(json: json) else { return }
            self?.post = post
        }
        postsListener = postsReference.addSnapshotListener { [weak self] snapshot, error in
            if let error = error { self?.postsError = error ; return }
            do {
                self?.posts = try snapshot?.documents
                    .map { $0.data() }
                    .map { try ForumPost.from(json: $0) } ?? []
            } catch { self?.postsError = error }
        }
    }
    
    deinit {
        postsListener?.remove()
        postListener?.remove()
        userVoteListener?.remove()
    }
    
    
    private func loadUser() {
        isLoadingUser = true
        userError = nil
        userVote = nil
        Task.detached {
            let result: Result<User?,Error>
            do { result = .success(try await .with(id: self.post.userID)) }
            catch { result = .failure(error) }
            Task { @MainActor in
                self.isLoadingUser = false
                switch result {
                case .failure(let error): self.userError = error
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
            .addSnapshotListener(includeMetadataChanges: true) { [weak self] snapshot, _ in
                let JSONs = snapshot?.documents.map({ $0.data() })
                let votes = try? JSONs?.map({ try ForumPostVote.from(json: $0) })
                self?.userVote = votes?.first
            }
    }
    
    
    func vote(up: Bool) {
        isLoadingVote = true
        voteError = nil
        Task.detached {
            let result: Result<(),Error>
            do {
                
                try await withThrowingTaskGroup(of: Void.self) { tasks in
                    
                    // old NIL - new UP = create UP || new DOWN = create DOWN
                    // old UP - new UP = delete || new DOWN = update DOWN
                    // old DOWN - new UP = update UP || new DOWN = delete
                    guard let user = await self.user else { throw UserNotSignedIn(goal: "\(up ? "up":"down")vote this post.") }
                    let post = await self.post
                    let upVoteIncrement, downVoteIncrement: Int
                    let votesRef = Firestore.firestore().collection("forum_posts_votes")
                    
                    if let currentVote = await self.userVote {
                        let currentVoteRef = votesRef.document(currentVote.id.uuidString)
                        
                        // DELETE
                        if currentVote.isUp == up {
                            upVoteIncrement = up ? -1 : 0
                            downVoteIncrement = up == false ? -1 : 0
                            try await currentVoteRef.delete()
                        }
                        // UPDATE
                        else {
                            upVoteIncrement = up ? 1 : -1
                            downVoteIncrement = up == false ? 1 : -1
                            try await currentVoteRef.updateData(["isUp":up])
                        }
                    }
                    
                    // CREATE
                    else {
                        upVoteIncrement = up ? 1 : 0
                        downVoteIncrement = up == false ? 1 : 0
                        let vote = ForumPostVote(id: UUID(), date: Date(), userID: user.id, postID: post.id, isUp: up)
                        try await votesRef.document(vote.id.uuidString).setData(try vote.JSONDictionary)
                    }
                    
                    // TRANSACTIONS
                    let currentPostRef = self.postsCollectionRef.document(post.id.uuidString)
                    tasks.addTask {
                        try await Firestore.firestore().runTransaction { transaction, errorPointer in
                            let oldCount: Int
                            do {
                                guard let json = try transaction.getDocument(currentPostRef).data() else { return nil }
                                oldCount = try ForumPost.from(json: json).upVotes
                            } catch let fetchError as NSError {
                                errorPointer?.pointee = fetchError
                                return nil
                            }
                            let newCount = oldCount + upVoteIncrement
                            transaction.updateData(["upVotes": newCount], forDocument: currentPostRef)
                            return newCount
                        }
                    }
                    tasks.addTask {
                        try await Firestore.firestore().runTransaction { transaction, errorPointer in
                            let oldCount: Int
                            do {
                                guard let json = try transaction.getDocument(currentPostRef).data() else { return nil }
                                oldCount = try ForumPost.from(json: json).downVotes
                            } catch let fetchError as NSError {
                                errorPointer?.pointee = fetchError
                                return nil
                            }
                            let newCount = oldCount + downVoteIncrement
                            transaction.updateData(["downVotes": newCount], forDocument: currentPostRef)
                            return newCount
                        }
                    }
                    try await tasks.waitForAll()
                }
                
                result = .success(())
            } catch { result = .failure(error) }
            Task { @MainActor in
                self.isLoadingVote = false
                switch result {
                case .failure(let error): self.voteError = error
                case .success: return
                }
            }
        }
    }
    
    
    func loadPosts() {
        isLoadingPosts = true
        postsError = nil
        Task.detached {
            let result: Result<[ForumPost],Error>
            do {
                let documents = try await self.postsReference.getDocuments().documents
                let posts = try documents.map { $0.data() }
                    .map { try ForumPost.from(json: $0) }
                result = .success(posts)
            } catch { result = .failure(error) }
            Task { @MainActor in
                self.isLoadingPosts = false
                switch result {
                case .failure(let error): self.postsError = error
                case .success(let posts): self.posts = posts
                }
            }
        }
    }
    
    func sendComment() {
        isSendingComment = true
        commentError = nil
        Task.detached {
            let result: Result<(),Error>
            do {
                let message = await self.commentEntry
                let post = await self.post
                guard message.isEmpty == false
                else { throw FPTError(custom: "Are serious man?! You want to send an empty comment? No! No! 🤬") }
                guard let firebaseUser = Auth.auth().currentUser
                else { throw UserNotSignedIn(goal: "comment on this post.") }
                
                let currentPostRef = self.postsCollectionRef.document(post.id.uuidString)
                try await Firestore.firestore().runTransaction { transaction, errorPointer in
                    let document: DocumentSnapshot
                    do {
                        try document = transaction.getDocument(currentPostRef)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    
                    guard let oldComments = document.data()?["comments"] as? Int else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve comments count from snapshot \(document)"
                            ]
                        )
                        errorPointer?.pointee = error
                        return nil
                    }
                    
                    transaction.updateData(["comments": oldComments + 1], forDocument: currentPostRef)
                    return oldComments + 1
                }
                
                let newPost = ForumPost(message: message, from: .init(firebaseUser), respondingTo: post)
                try await self.postsCollectionRef.document(newPost.id.uuidString).setData(try newPost.JSONDictionary)
                result = .success(())
            } catch { result = .failure(error) }
            Task { @MainActor in
                self.isSendingComment = false
                switch result {
                case .failure(let error): self.commentError = error
                case .success: self.commentEntry = ""
                }
            }
        }
    }
    
    
    func delete() {
        isDeletingPost = true
        deletionError = nil
        Task.detached {
            let result: Result<(),Error>
            do {
                try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                try await self.postReference.delete()
                result = .success(())
            } catch { result = .failure(error) }
            Task { @MainActor in
                self.isDeletingPost = false
                switch result {
                case .failure(let error): self.deletionError = error
                case .success: self.isDeleted = true
                }
            }
        }
    }
    
    
}
