//
//  ForumView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit
import AuthenticationKit

struct ForumView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @StateObject private var model = ForumViewModel()
    @State private var presentNewPost = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForumHeader()
            ZStack {
                if model.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else if let error = model.error {
                    errorContent(error)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    if model.posts.isEmpty {
                        emptyContent
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        content(model.posts)
                    }
                }
            }
            .safeAreaInset(edge: .top) { filterHeader }
        }
        .fullScreenCover(isPresented: $presentNewPost) {
            if let user = authManager.user {
                NewPostView(user: user)
            } else {
                AuthenticationView()
            }
        }
    }
    
    func errorContent(_ error: Error) -> some View {
        ErrorView(error: error.localizedDescription) {
            .init { model.reloadPosts() }
        }
        .padding()
    }
    
    func content(_ posts: [ForumPost]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(posts) { ForumPostCell(post: $0) }
            }
            .padding(.vertical)
        }
    }
    
    var emptyContent: some View {
        ErrorView(
            title: "No post here 🥸",
            error: "Do you have somthing to say? Well, say it! Right now! Here is a button to help you. Use it.") {
            .init(title: "Say something", completion: presentWriteView)
        }
        .padding()
    }
    
    func presentWriteView() { presentNewPost = true }
    
    var filterHeader: some View {
        VStack(spacing: 0) {
//            HStack(spacing: 8) {
//                Text("Topic :".uppercased())
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .foregroundColor(.secondary)
//                Text("Apple,".uppercased())
//                    .fontWeight(.heavy)
//                Text("most recent".lowercased())
//                    .fontWeight(.bold)
//                    .foregroundColor(.pink)
//            }
//            .font(.headline)
//            .foregroundColor(Color(.label))
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(.background)
//            .overlay(filterButton)
            
            Divider()
        }
    }
    
    var filterButton: some View {
        Button(action: {  }, label: {
            Image(systemName: "line.3.horizontal.decrease")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color(UIColor.tertiaryLabel))
        })
            .buttonStyle(BounceButtonStyle())
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func presentFilter() {
        
    }
}

struct ForumView_Previews: PreviewProvider {
    static var previews: some View {
        ForumView()
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
