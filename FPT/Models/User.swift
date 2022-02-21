//
//  User.swift
//  FPT
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import AuthenticationKit
import FirebaseAuth
import FirebaseFirestore
import CodableKit


struct User: AKUser, Identifiable, Codable {
    
    let id: String
    var username: String?
    var email: String?
    let emailVerified: Bool
    var phoneNumber: String?
    var profileImageURL: URL?
    
    static func with(id: String) async throws -> User? {
        guard let json = try await Firestore.firestore()
                .collection("users").document(id)
                .getDocument().data()
        else { return nil }
        return try User.from(json: json)
    }
    init(_ firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.username = firebaseUser.displayName
        self.email = firebaseUser.email
        self.emailVerified = firebaseUser.isEmailVerified
        self.phoneNumber = firebaseUser.phoneNumber
        self.profileImageURL = firebaseUser.photoURL
    }
    
    private var reference: DocumentReference { Firestore.firestore().collection("users").document(id) }
    func updateInFirestoreDatabase() async throws { try await reference.setData(try JSONDictionary) }
    func delete() async throws { try await reference.delete() }
    
    static var exemple: User { .exemple() }
    static func exemple(
        username: String = "Hans Rietmann",
        email: String = "hrietmann@icloud.com",
        emailVerified: Bool = true,
        phoneNumber: String = "+33 1 23 45 67 89",
        profileImageURL: String = "https://pbs.twimg.com/profile_images/1263375874985992195/TPhY9iGp_400x400.png"
    ) -> User
    { .init() }
    private init(
        username: String = "Hans Rietmann",
        email: String = "hrietmann@icloud.com",
        emailVerified: Bool = true,
        phoneNumber: String = "+33 1 23 45 67 89",
        profileImageURL: String? = "https://pbs.twimg.com/profile_images/1263375874985992195/TPhY9iGp_400x400.png"
    ) {
        self.id = UUID().uuidString
        self.username = username
        self.email = email
        self.emailVerified = emailVerified
        self.phoneNumber = phoneNumber
        if let profileImageURL = profileImageURL {
            self.profileImageURL = URL(string: profileImageURL)
        } else {
            self.profileImageURL = nil
        }
    }
    
}
