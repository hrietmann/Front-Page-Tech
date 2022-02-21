//
//  CapsuleLink.swift
//  FPT
//
//  Created by Hans Rietmann on 16/02/2022.
//

import SwiftUI

struct CapsuleLink: View {
    
    let icon: String
    let title: String
    let destination: URL
    
    var body: some View {
        Link(destination: destination) {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .foregroundColor(.label)
                    .font(.headline)
            }
            .padding(.trailing)
            .padding(.leading, 12)
            .padding(.vertical, 8)
            .background(.tertiarySystemBackground)
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(Color(.tertiaryLabel), lineWidth: 0.3)
            }
        }
    }
}

struct CapsuleLink_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                CapsuleLink(icon: "twitter", title: "Genius Bar", destination: URL(string: "https://twitter.com/geniusbarcast")!)
                    .accentColor(Color("twitter"))
                CapsuleLink(icon: "youtube", title: "Sam", destination: URL(string: "https://www.youtube.com/iupdate")!)
                CapsuleLink(icon: "youtube", title: "Jon", destination: URL(string: "https://www.youtube.com/user/frontpagetech")!)
                CapsuleLink(icon: "twitter", title: "Sam", destination: URL(string: "http://twitter.com/iupdate")!)
                    .accentColor(Color("twitter"))
                CapsuleLink(icon: "twitter", title: "Jon", destination: URL(string: "http://twitter.com/jon_prosser")!)
                    .accentColor(Color("twitter"))
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
        }
        .padding(.top, 8)
        .padding(.bottom)
    }
}
