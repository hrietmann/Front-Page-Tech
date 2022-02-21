//
//  NewPostViewModel.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import SwiftUI
import FirebaseFirestore



class NewPostViewModel: ObservableObject {
    
    
    let user: Authenticator.User
    let placeholder: String
    @Published private(set) var isLoading = false
    @Published private(set) var isCreated = false
    @Published var error: Error?
    @Published var message: String
    
    
    init(user: Authenticator.User, placeholder: String) {
        self.user = user
        self.placeholder =  placeholder
        self.message = placeholder
    }
    
    
    func createNewPost() {
        isLoading = true
        error = nil
        Task.detached {
            let result: Result<(),Error>
            if !self.message.isEmpty {
                let post = ForumPost(message: self.message, from: self.user)
                let data = try post.JSONDictionary
                let database = Firestore.firestore()
                let collection = database.collection("forum_posts")
                let document = collection.document(post.id.uuidString)
                try await document.setData(data)
                result = .success(())
            } else {
                result = .failure(ForumPostMessageMissing())
            }
            Task { @MainActor in
                self.isLoading = true
                switch result {
                case .success: self.isCreated = true
                case .failure(let error): self.error = error
                }
            }
        }
    }
    
    
}
