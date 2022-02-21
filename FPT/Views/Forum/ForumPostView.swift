//
//  ForumPostView.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import SwiftUI
import SwiftUIX
import SPAlert
import AuthenticationKit


struct ForumPostView: View {
    
    @EnvironmentObject private var authManager: AuthManager<Authenticator>
    @StateObject private var model: ForumPostViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var presentAuthentication = false
    @State private var presentError = false
    private var error: Error? {
        model.userError ?? model.postsError ?? model.commentError ?? model.deletionError ?? model.voteError
    }
    @State private var presentDeletionConfirmation = false
    
    init(_ post: ForumPost) {
        _model = .init(wrappedValue: .init(post: post))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if model.isLoadingPosts || model.isDeletingPost {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .safeAreaInset(edge: .top) { header }
                } else if let error = model.postsError {
                    ErrorView(error: error.localizedDescription) {
                        .init(completion: { model.loadPosts() })
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .safeAreaInset(edge: .top) { header }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            header
                            ForEach(model.posts) { ForumPostCell(post: $0) }
                        }
                    }
                    .safeAreaInset(edge: .bottom) { footer }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    SwiftUI.Menu {
                        menuItems
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Pull down to dismiss")
                        .lineLimit(2)
                        .font(.caption)
                        .foregroundColor(.tertiaryLabel)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("OK", role: .cancel, action: dismiss.callAsFunction)
                        .font(.body, weight: .bold)
                }
            }
            .disabled(model.isDeletingPost)
        }
        .onReceive(model.$userError) { presentError = $0 != nil }
        .onReceive(model.$commentError) { presentError = $0 != nil }
        .onReceive(model.$voteError) { presentError = $0 != nil }
        .onReceive(model.$deletionError) { presentError = $0 != nil }
        .onReceive(model.$isDeleted) { if $0 { dismiss() } }
        .alert("Error", isPresented: $presentError) {
            Button("OK") {
                if model.userError != nil { model.userError = nil }
                else if model.commentError != nil { model.commentError = nil }
                else if model.voteError != nil { model.voteError = nil }
                else if model.deletionError != nil { model.deletionError = nil }
            }
        } message: {
            Text(error?.localizedDescription ?? "Error")
        }
    }
    
    @ViewBuilder
    var menuItems: some View {
        if model.user == nil {
            Button("Report Post", systemImage: SFSymbolName(rawValue: "flag")!) {
                let alertView = SPAlertView(
                    title: "Reported",
                    message: "This post has been reported to our mederators.",
                    preset: SPAlertIconPreset.done)
                alertView.dismissByTap = true
                alertView.duration = 3
                alertView.present(haptic: .success, completion: nil)
            }
        } else {
//            Button("Edit", systemImage: SFSymbolName(rawValue: "pencil")!) { }
            Button(role: .destructive) {
                model.delete()
            } label: { Label("Delete", systemImage: "trash") }
            .alert("Sure?", isPresented: $presentDeletionConfirmation) {
                Button("OK") {
                    
                }
            } message: {
                Text("Are you sure about that? 😮")
            }
        }
    }
    
    var header: some View {
        VStack(spacing: 16 + 8) {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    avatar(of: model.user)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Posted by")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(model.post.date.timeAgo)
                                .font(.subheadline)
                                .foregroundColor(Color(.tertiaryLabel))
                        }
                        Text(model.user?.username ?? "USERNAME")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .redacted(reason: model.isLoadingUser ? .placeholder : [])
                }
                Text(model.post.message)
                    .font(.title3)
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            HStack(spacing: 16 + 8) {
                Button {
                    model.vote(up: true)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrowtriangle.up\(model.userVote?.isUp == true ? ".fill":"")")
                            .foregroundColor(.green)
                        Text(model.post.upVotes.short)
                    }
                }

                Button {
                    model.vote(up: false)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrowtriangle.down\(model.userVote?.isUp == false ? ".fill":"")")
                            .foregroundColor(.red)
                        Text(model.post.downVotes.short)
                    }
                }

                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "eye")
                    Text(model.post.views.short)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "bubble.left")
                    Text(model.post.comments.short)
                }
            }
            .padding(.horizontal)
            .font(.headline)
            .disabled(model.isLoadingVote)
            .opacity(model.isLoadingVote ? 0.4:1)
            
            Divider()
        }
        .padding(.top)
        .background(.background)
        .animation(.easeInOut)
    }
    
    func avatar(of user: User?, size: Double = 50) -> some View {
        SwiftUI.AsyncImage(url: user?.profileImageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color(.label))
                .frame(width: 24/50 * size, height: 24/50 * size, alignment: .center)
        }
        .frame(width: size, height: size)
        .background(.ultraThickMaterial)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.secondarySystemFill), lineWidth: 0.5)
        }
    }
    
    var footer: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 16) {
                avatar(of: authManager.user, size: 45)
                TextField("Comment on this 👀", text: $model.commentEntry)
                    .textFieldStyle(.frontPageTech)
                    .submitLabel(.send)
                    .keyboardDismissMode(.onDrag)
                    .onSubmit {
                        guard !model.commentEntry.isEmpty else { return }
                        model.sendComment()
                    }
            }
            .blur(radius: authManager.user == nil ? 16 : 0)
            .padding()
            .disabled(authManager.user == nil)
            .overlay {
                if authManager.user == nil {
                    Button {
                        presentAuthentication = true
                    } label: {
                        Text("Have a comment to write? ")
                            .foregroundColor(.secondary)
                            .font(.subheadline) +
                        Text("Sign in")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .fullScreenCover(isPresented: $presentAuthentication) {
                        AuthenticationView()
                    }
                } else { EmptyView() }
            }
        }
        .background(.background)
        .disabled(model.isSendingComment)
        .foregroundColor(model.isSendingComment ? .tertiaryLabel:.label)
    }
}

struct ForumPostView_Previews: PreviewProvider {
    static var previews: some View {
        ForumPostView(.exemple)
            .environmentObject(AuthManager(authenticator: Authenticator()))
    }
}
