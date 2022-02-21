//
//  CommentView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit


struct ForumPostCell: View {
    
    @StateObject private var model: ForumPostCellModel
    @State private var presentPost = false
    
    init(post: ForumPost) {
        _model = .init(wrappedValue: .init(post: post))
    }
    
    var body: some View {
        Button {
            presentPost.toggle()
        } label: {
            VStack(spacing: 16) {
                header
                Text(model.post.message)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                footer
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .sheet(isPresented: $presentPost) {
                ForumPostView(model.post)
            }
        }
        .foregroundColor(.label)
        .buttonStyle(BounceButtonStyle())
    }
    
    var header: some View {
        HStack(alignment: .top, spacing: 8) {
            userImage
            VStack(alignment: .leading) {
                HStack {
                    Text("Posted by")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(model.post.date.timeAgo)
                        .font(.caption)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                Text(model.user?.username ?? "USERNAME")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .redacted(reason: model.isLoadingUser ? .placeholder : [])
        }
    }
    
    var footer: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "arrowtriangle.up\(model.userVote?.isUp == true ? ".fill":"")")
                    .foregroundColor(.green)
                Text(model.post.upVotes.short)
            }
            HStack(spacing: 6) {
                Image(systemName: "arrowtriangle.down\(model.userVote?.isUp == false ? ".fill":"")")
                    .foregroundColor(.red)
                Text(model.post.downVotes.short)
            }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "eye")
                Text(model.post.views.short)
            }
            HStack(spacing: 6) {
                Image(systemName: "bubble.left")
                Text(model.post.comments.short)
            }
        }
        .font(.footnote)
        .animation(.easeInOut)
    }
    
    var userImage: some View {
        SwiftUI.AsyncImage(url: model.user?.profileImageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.opacity)
                .animation(.easeInOut)
        } placeholder: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFill()
                .foregroundStyle(Color(.label))
                .frame(width: 16, height: 16, alignment: .center)
                .transition(.opacity)
                .animation(.easeInOut)
        }
        .frame(width: 35, height: 35)
        .background(.ultraThickMaterial)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.secondarySystemFill), lineWidth: 0.5)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        ForumPostCell(post: .exemple)
    }
}
