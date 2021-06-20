//
//  NewsView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI


struct NewsView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject private var manager = HomeManager.shared
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            NewsHeader()
                .zIndex(0)
            
            HStack(spacing: 0) {
                MenuView(selected: $manager.menu)
                manager.menu.content(namespace: namespace)
                .overlay(
                    Button(action: { openURL(URL(string: "https://twitter.com/jon_prosser")!) }) {
                    Image("twitter")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .frame(width: 54, height: 54)
                        .background(Color("twitter"))
                        .clipShape(Circle())
                }
                        .buttonStyle(BounceButtonStyle())
                        .padding(.trailing)
                        .padding(.bottom)
                        .shadow(color: Color("twitter").opacity(0.5), radius: 16, x: 1, y: 6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                )
            }
            .zIndex(2)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(namespace: Namespace().wrappedValue)
    }
}
