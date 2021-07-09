//
//  AppDelegate.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setUPURLCache()
        return true
    }
    
    private func setUPURLCache() {
        let memoryCapacity = 150 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "cachedFiles")
        URLCache.shared = cache
        URLSession.shared.configuration.urlCache = cache
    }
}
