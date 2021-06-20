//
//  ForumHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct ForumHeader: View {
    private let iconSize: CGFloat = 20
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Forum".uppercased())
                    .font(.title.weight(.black).italic())
                    .padding(20)
                Spacer()
                
                HStack(spacing: 30) {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    }
                    .foregroundColor(Color(.label))
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    }
                    
                    Button(action: {}) {
                        Image("john")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                }
                .buttonStyle(BounceButtonStyle())
                .padding()
            }
            .frame(height: UIScreen.main.bounds.width * 0.2)
            .zIndex(-2)
            
            HStack(spacing: 8) {
                Text("Topic :".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text("Apple,".uppercased())
                    .fontWeight(.heavy)
                Text("most recent".lowercased())
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
            }
            .font(.headline)
            .foregroundColor(Color(.label))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.tertiarySystemFill))
            .overlay(
                Image(systemName: "line.3.horizontal.decrease")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            )
            
            Divider()
        }
    }
}

struct ForumHeader_Previews: PreviewProvider {
    static var previews: some View {
        ForumHeader()
    }
}
