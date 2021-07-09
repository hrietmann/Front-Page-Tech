//
//  ContentView.swift
//  FPT
//
//  Created by Hans Rietmann on 11/06/2021.
//

import SwiftUI
import Combine
import FeedKit







struct HomeView: View {
    
    @StateObject private var manager = HomeManager.shared
    
    var body: some View {
        ZStack {
            TabsView()
            
            if let page = manager.present {
                page
                    .zIndex(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
//            if let article = manager.showArticle {
//                ArticlePage(dummy: article, frame: .zero)
//            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
