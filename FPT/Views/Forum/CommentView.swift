//
//  CommentView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct CommentView: View {
    
    let comment: Comment
    @State private var presentUnderConstruction = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(comment.writerProfile)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Posted by")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(comment.writerName)
                        .font(.headline)
                        .bold()
                }
                Spacer()
                Text(comment.date.timeAgo)
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            
            Text(comment.comment)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.green)
                    Text(comment.upVotes.short)
                }
                HStack(spacing: 6) {
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(.red)
                    Text(comment.downVotes.short)
                }
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "eye")
                    Text(comment.views.short)
                }
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left")
                    Text(comment.downVotes.short)
                }
            }
            .padding(.top)
            .font(.footnote)
        }
        .onTapGesture {
            presentUnderConstruction.toggle()
        }
        .padding(22)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.horizontal)
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: .list[0])
    }
}
