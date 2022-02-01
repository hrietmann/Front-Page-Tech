//
//  User.swift
//  FPT
//
//  Created by Hans Rietmann on 27/01/2022.
//

import Foundation
import AuthenticationKit
import FirebaseAuth


struct User: AKUser {
    
    let id: String
    let username: String?
    let email: String?
    let emailVerified: Bool
    let phoneNumber: String?
    let profileImageURL: URL?
    
    init(_ firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.username = firebaseUser.displayName
        self.email = firebaseUser.email
        self.emailVerified = firebaseUser.isEmailVerified
        self.phoneNumber = firebaseUser.phoneNumber
        self.profileImageURL = firebaseUser.photoURL
    }
    
}
