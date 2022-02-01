//
//  Authenticator.swift
//  FPT
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import AuthenticationKit
import StringKit
import Combine
import FirebaseAuth
import FirebaseStorage
import CoreGraphics



class Authenticator: AKAuthenticator {
    
    
    
    static var passwordConstraints = PasswordConstraint.allCases
    
    
    
    @Published public var currentUser: User?
    public var currentUserPublisher: Published<User?>.Publisher { $currentUser }
    public var cachedUser: User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return .init(firebaseUser)
    }
    private var authListner: AuthStateDidChangeListenerHandle?
    
    
    
    public init() {
        Auth.auth().useAppLanguage()
    }
    
    
    
    public func addRemoteUpdatesLisnters(for user: User) async throws {
        authListner = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user { self.currentUser = .init(user) }
            else { self.currentUser = nil }
        }
    }
    
    
    public func removeRemoteUpdatesListners(for user: User) async throws {
        guard let authListner = authListner else { return }
        Auth.auth().removeStateDidChangeListener(authListner)
    }
    
    
    public func signUp(username: String, email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        let change = result.user.createProfileChangeRequest()
        change.displayName = username
        try await change.commitChanges()
        return .init(result.user)
    }
    
    
    public func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        return .init(result.user)
    }
    
    
    public func signOut(user: User) async throws {
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        try Auth.auth().signOut()
    }
    
    
    func change(email: String, with password: String, of user: User) async throws {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
        try await Auth.auth().currentUser?.updateEmail(to: email)
    }
    
    
    func change(password currentPassword: String, to newPassword: String, with email: String, of user: User) async throws {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
        try await Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
    
    
    func sendEmailVerification(for user: User) async throws {
        try await Auth.auth().currentUser?.sendEmailVerification()
    }
    
    
    func sendPasswordReset(to email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    func change(username: String, of user: User) async throws {
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.displayName = username
        try await change?.commitChanges()
    }
    
    
    func change(profile image: UniversalImage?, of user: User) async throws {
        
        // Remove existing profile image
        if let currentImageURL = Auth.auth().currentUser?.photoURL {
            let reference = Storage.storage().reference(forURL: currentImageURL.absoluteString)
            try await reference.delete()
        }
        
        // Upload the new one
        let url: URL?
        let imageName = UUID().uuidString
        if let data = image?.jpegData(compressionQuality: 1) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let reference = Storage.storage().reference()
            let imageRef = reference.child("images/\(imageName).jpeg")
            url = try await imageRef.upload(image: data, with: metadata)
        } else { url = nil }
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.photoURL = url
        try await change?.commitChanges()
    }
    
    
    func delete(user: User) async throws {
        try await Auth.auth().currentUser?.delete()
    }
    
    
    
}




extension StorageReference {
    
    @available(*, renamed: "upload(image:with:)")
    func upload(image data: Data, with metadata: StorageMetadata? = nil, _ completion: @escaping (Result<URL,Swift.Error>) -> ()) {
        Task {
            do {
                let result = try await upload(image: data, with: metadata)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func upload(image data: Data, with metadata: StorageMetadata? = nil) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    continuation.resume(with: .failure(error))
                    return
                }
                self.downloadURL { (url, error1) in
                    guard let downloadURL = url else {
                        continuation.resume(with: .failure(error1!))
                        return
                    }
                    continuation.resume(with: .success(downloadURL))
                }
            }
        }
    }
    
}
