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
    func content(namespace: Namespace.ID) -> some View {
        Group {
            switch id.uuidString {
            case Menu.list[1].id.uuidString: AppleView(namespace: namespace)
            case Menu.list[2].id.uuidString: AndroidView(namespace: namespace)
            case Menu.list[3].id.uuidString: VideosView()
            case Menu.list[4].id.uuidString: LeakView()
            default: ExclusivesView(namespace: namespace)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    static let list = ["Exclusives", "Apple", "Android", "Videos", "Got a leak ?"]
        .map { Menu(title: $0) }
}
