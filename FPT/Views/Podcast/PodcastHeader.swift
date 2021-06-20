//
//  PodcastHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct PodcastHeader: View {
    private let iconSize: CGFloat = 20
    @State private var offset: CGFloat = 0
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: UIApplication.shared.windows[0].safeAreaInsets.top)
            HStack(spacing: 16) {
                Text("Podcast".uppercased())
                    .font(.title.weight(.black).italic())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 20)
                Spacer()
                search
                account
            }
        }
        .padding(.horizontal)
        .background(Color("podcast"))
        .buttonStyle(BounceButtonStyle())
    }
    
    var account: some View {
        Button(action: {}) {
            Image("john")
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        }
    }
    
    var search: some View {
        Button(action: {}) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .padding(.vertical)
        }
        .foregroundColor(Color.white)
    }
    
    
}

struct PodcastHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            PodcastHeader()
            ScrollView {
                VStack(spacing: 0) {
                    PodcastCover()
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: UIScreen.main.bounds.height)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
