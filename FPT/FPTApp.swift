//
//  FPTApp.swift
//  FPT
//
//  Created by Hans Rietmann on 11/06/2021.
//

import SwiftUI
import AuthenticationKit

@main
struct FPTApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authManager = AuthManager(authenticator: Authenticator())
    @StateObject private var homeManager = HomeManager.shared
    @StateObject private var podcastModel = PodcastViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(authManager)
                .environmentObject(homeManager)
                .environmentObject(podcastModel)
        }
    }
}
