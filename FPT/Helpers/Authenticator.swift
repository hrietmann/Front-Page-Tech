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
import FirebaseFirestore
import FirebaseStorage
import CoreGraphics
import CodableKit



class Authenticator: AKAuthenticator {
    
    
    
    static var passwordConstraints = PasswordConstraint.allCases
    
    
    
    @Published public var currentUser: User?
    public var currentUserPublisher: Published<User?>.Publisher { $currentUser }
    public var cachedUser: User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return .init(firebaseUser)
    }
    private var authListner: AuthStateDidChangeListenerHandle?
    private var userMetadataListener: ListenerRegistration?
    
    
    
    public init() {
        Auth.auth().useAppLanguage()
    }
    
    
    
    public func addRemoteUpdatesLisnters(for user: User) async throws {
        authListner = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user { self?.currentUser = .init(user) }
            else { self?.currentUser = nil }
        }
        userMetadataListener = Firestore.firestore().collection("users").document(user.id).addSnapshotListener { [weak self] snapshot, error in
            if let error = error { fatalError(error.localizedDescription) }
            if let json = snapshot?.data(), let user = try? User.from(json: json) { self?.currentUser = user }
        }
    }
    
    
    public func removeRemoteUpdatesListners(for user: User) async throws {
        if let authListner = authListner { Auth.auth().removeStateDidChangeListener(authListner) }
        userMetadataListener?.remove()
    }
    
    
    public func signUp(username: String, email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        let change = result.user.createProfileChangeRequest()
        change.displayName = username
        try await change.commitChanges()
        let user = User(result.user)
        try await user.updateInFirestoreDatabase()
        return user
    }
    
    
    public func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        return .init(result.user)
    }
    
    
    func signInWithApple(tokenID: String, nonce: String) async throws -> User {
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: tokenID,
                                                  rawNonce: nonce)
        let result = try await Auth.auth().signIn(with: credential)
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        let user = User(result.user)
        try await user.updateInFirestoreDatabase()
        return user
    }
    
    
    public func signOut(user: User) async throws {
        #if !DEBUG
        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        #endif
        try Auth.auth().signOut()
    }
    
    
    func change(email: String, with password: String, of user: User) async throws {
        let currentEmail = currentUser?.email ?? ""
        let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: password)
        try await Auth.auth().currentUser?.reauthenticate(with: credential)
        try await Auth.auth().currentUser?.updateEmail(to: email)
        currentUser?.email = email
        try await currentUser?.updateInFirestoreDatabase()
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
        let currentUser = self.currentUser
        try await Auth.auth().sendPasswordReset(withEmail: email)
        self.currentUser = currentUser
    }
    
    
    func change(username: String, of user: User) async throws {
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.displayName = username
        try await change?.commitChanges()
        currentUser?.username = username
        try await currentUser?.updateInFirestoreDatabase()
    }
    
    
    func change(profile image: UniversalImage?, of user: User) async throws {
        
        // Remove existing profile image
        if let currentImageURL = Auth.auth().currentUser?.photoURL {
            let reference = Storage.storage().reference(forURL: currentImageURL.absoluteString)
            try await reference.delete()
        }
        
        // Upload the new one
        let url: URL?
        let imageName = user.id
        if let data = image?.jpegData(compressionQuality: 1) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let imageData: Data?
            let maxSize = 200_000
            if data.count < maxSize { imageData = data }
            else {
                let compression = CGFloat(maxSize) / CGFloat(data.count)
                imageData = image?.jpegData(compressionQuality: compression)
            }
            
            let reference = Storage.storage().reference()
            let imageRef = reference.child("images/\(imageName).jpeg")
            if let imageData = imageData {
                url = try await imageRef.upload(image: imageData, with: metadata)
            } else { url = nil }
            
        } else { url = nil }
        let change = Auth.auth().currentUser?.createProfileChangeRequest()
        change?.photoURL = url
        try await change?.commitChanges()
        currentUser?.profileImageURL = url
        try await currentUser?.updateInFirestoreDatabase()
    }
    
    
    func delete(user: User) async throws {
        #if !DEBUG
        try await Task.sleep(nanoseconds: 8 * 1_000_000_000)
        #endif
        try await user.delete()
        try await Auth.auth().currentUser?.delete()
        let reference = Storage.storage().reference().child("images/\(user.id).jpeg")
        try await reference.delete()
        currentUser = nil
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
