//
//  FPTApp.swift
//  FPT
//
//  Created by Hans Rietmann on 11/06/2021.
//

import SwiftUI

@main
struct FPTApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
