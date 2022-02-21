//
//  Menu.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import Foundation
import SwiftUI




struct Menu: Identifiable {
    let id = UUID()
    let title: String
    var content: some View {
        Group {
            switch id.uuidString {
            case Menu.list[0].id.uuidString: NewsFeed(feed: .today)
            case Menu.list[1].id.uuidString: NewsFeed(feed: .exclusives)
            case Menu.list[2].id.uuidString: NewsFeed(feed: .apple)
            case Menu.list[3].id.uuidString: NewsFeed(feed: .android)
//            case Menu.list[4].id.uuidString: NewsFeed(feed: .videos)
//            default: LeakView()
            default: NewsFeed(feed: .videos)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    static let list = ["Today", "Exclusives", "Apple", "Android", "Videos"/*, "Got a leak ?"*/]
        .map { Menu(title: $0) }
}
