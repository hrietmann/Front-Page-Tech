//
//  ForumHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit
import AuthenticationKit

struct ForumHeader: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    private let iconSize: CGFloat = 20
    @State private var presentUnderConstruction = false
    @State private var presentNewPost = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Forum".uppercased())
                .font(.title.weight(.black).italic())
                .padding(20)
            Spacer()
            
            HStack(spacing: 30) {
                SeachHeaderButton().hidden()
                
                Button(action: {
                    presentNewPost.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconSize, height: iconSize)
                        .padding(.vertical)
                }
                .fullScreenCover(isPresented: $presentNewPost) {
                    if let user = authManager.user {
                        NewPostView(user: user)
                    } else {
                        AuthenticationView()
                    }
                }
                
                AccountAvatarView()
            }
            .buttonStyle(BounceButtonStyle())
            .padding()
        }
        .frame(height: UIScreen.main.bounds.width * 0.2)
        .zIndex(-2)
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
}

struct ForumHeader_Previews: PreviewProvider {
    static var previews: some View {
        ForumHeader()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
