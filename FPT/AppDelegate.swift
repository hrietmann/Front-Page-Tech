//
//  AppDelegate.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUPURLCache()
        FirebaseApp.configure()
        
//        #if DEBUG
//        configureDevelopmentProfile()
//        #else
        configureProductionProfile()
//        #endif
        
        return true
    }
    
    private func setUPURLCache() {
        let memoryCapacity = 150 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "cachedFiles")
        URLCache.shared = cache
        URLSession.shared.configuration.urlCache = cache
    }
    
    private func configureDevelopmentProfile() {
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
        
        let firestoreSettings = Firestore.firestore().settings
        firestoreSettings.host = "localhost:8080"
        firestoreSettings.isPersistenceEnabled = false
        firestoreSettings.isSSLEnabled = false
        Firestore.firestore().settings = firestoreSettings
        Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
    }
    
    private func configureProductionProfile() {
        
    }
}
