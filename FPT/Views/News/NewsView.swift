//
//  NewsView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit


struct NewsView: View {
    
    @Environment(\.openURL) var openURL
    @StateObject private var manager = HomeManager.shared
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 0) {
            NewsHeader()
                .zIndex(0)
            
            HStack(spacing: 0) {
                MenuView(selected: $manager.menu)
                manager.menu.content
                    .overlay(twitterButton)
            }
            .zIndex(2)
        }
        .onAppear { appeared = true }
    }
    
    @ViewBuilder var twitterButton: some View {
        if appeared {
            Button {
                openURL(URL(string: "https://twitter.com/jon_prosser")!)
            } label: { twitterButtonLabel }
            .buttonStyle(BounceButtonStyle())
            .padding(.trailing)
            .padding(.bottom)
            .shadow(color: Color("twitter").opacity(0.5), radius: 16, x: 1, y: 6)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        } else {
            EmptyView()
        }
    }
    
    var twitterButtonLabel: some View {
        Image("twitter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundColor(.white)
            .frame(width: 54, height: 54)
            .background(Color("twitter"))
            .clipShape(Circle())
            .transition(.move(edge: .bottom))
            .animation(.spring())
            .overlay(twitterNotification)
    }
    
    var twitterNotification: some View {
        Text("2")
            .font(.caption.weight(.heavy))
            .aspectRatio(1, contentMode: .fit)
            .padding(8)
            .background(Color.red)
            .clipShape(Circle())
            .foregroundColor(.white)
            .offset(x: 8, y: -8)
            .shadow(color: Color.red.opacity(0.5), radius: 8, x: 1, y: 3)
            .transition(.move(edge: .bottom))
            .animation(.spring().delay(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
