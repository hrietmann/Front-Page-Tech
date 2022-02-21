//
//  File.swift
//  FPT
//
//  Created by Hans Rietmann on 02/02/2022.
//

import SwiftUI
import FirebaseFirestore
import CodableKit




@MainActor
class ForumViewModel: ObservableObject {
    
    
    @Published private(set) var posts = [ForumPost]()
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    
    
    private let postsReference = Firestore.firestore()
        .collection("forum_posts")
        .whereField("isDiscussionRoot", isEqualTo: true)
        .order(by: "date", descending: true)
        .limit(to: 50)
    
    
    // MARK: - Listners -
    private var postsListner: ListenerRegistration? = nil
    
    
    init() {
        reloadPosts()
        postsListner = postsReference.addSnapshotListener { snapshot, error in
            self.error = error
            guard let documents = snapshot?.documents else { return }
            do { self.posts = try documents.map { doc in try ForumPost.from(json: doc.data()) } }
            catch { self.error = error }
        }
    }
    
    deinit {
        postsListner?.remove()
    }
    
    func reloadPosts() {
        isLoading = true
        error = nil
        posts = []
        Task.detached {
            let result: Result<[ForumPost],Error>
            do {
                let posts = try await self.postsReference
                    .getDocuments().documents
                    .map { try ForumPost.from(json: $0.data()) }
                result = .success(posts)
            } catch { result = .failure(error) }
            Task { @MainActor in
                self.isLoading = false
                switch result {
                case .failure(let error): self.error = error
                case .success(let posts): self.posts = posts
                }
            }
        }
    }
    
    
}
