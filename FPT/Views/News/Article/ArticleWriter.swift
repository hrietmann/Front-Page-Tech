//
//  ArticleWriter.swift
//  FPT
//
//  Created by Hans Rietmann on 10/07/2021.
//

import SwiftUI
import ViewKit


struct ArticleWriter: View {
    
    let article: Article?
    @State private var presentUnderConstruction = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                AsyncImage(url: article?.authorImageURL,
                           placeholder: Image("FPT App Icon")
                            .resizable()
                            .aspectRatio(contentMode: .fill))
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("By \(article?.author ?? "Fah Pah Tah")")
                        .font(.headline)
                        .bold()
                    Text("Published \(article?.createdAt.timeAgo ?? "- time ago")")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { presentUnderConstruction.toggle() }) {
                    Label("Share", systemImage: "paperplane.fill")
                        .foregroundColor(.pink)
                        .font(.footnote.bold())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Capsule())
                }
                .buttonStyle(BounceButtonStyle())
            }
            
            warning
        }
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
    
    var warning: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("⚠️")
                .font(.headline)
            Text("The news bellow is only dummy content to show the general layout. Take note that multiple features are missing in this early version like interactive 3D renders preview, links to outside content, integrated video preview, and much more… Stay tuned !")
                .font(.footnote.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray)
        }
        .padding(16)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ArticleWriter_Previews: PreviewProvider {
    static var previews: some View {
        ArticleWriter(article: nil)
    }
}
