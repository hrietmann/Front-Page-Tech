//
//  PodcastHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit

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
                SeachHeaderButton(color: .white)
                AccountView()
            }
        }
        .padding(.horizontal)
        .background(Color("podcast"))
        .buttonStyle(BounceButtonStyle())
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
