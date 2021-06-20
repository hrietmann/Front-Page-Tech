//
//  ContentView.swift
//  FPT
//
//  Created by Hans Rietmann on 11/06/2021.
//

import SwiftUI
import Combine




class HomeManager: ObservableObject {
    
    static let shared = HomeManager()
    private init() {}
    
    @Published var menu = Menu.list[0]
    @Published var showArticle: Article? = nil
}




struct HomeView: View {
    
    @Namespace private var namespace
    @StateObject private var manager = HomeManager.shared
    
    var body: some View {
        ZStack {
            TabsView(namespace: namespace)
            
            if let article = manager.showArticle {
                ArticlePage(article: article, namespace: namespace)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
