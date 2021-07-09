//
//  HomeManager.swift
//  FPT
//
//  Created by Hans Rietmann on 27/06/2021.
//

import Foundation
import FeedKit
import UIKit
import SwiftUI



class HomeManager: ObservableObject {
    
    static let shared = HomeManager()
    private init() {}
    
    @Published var menu = Menu.list[0]
    @Published private(set) var present: AnyView? = nil
    
    func present<Page:View>(_ page: Page) {
        present = AnyView(page)
    }
    
    func dimissCurrentPage() {
        present = nil
    }
    
}
