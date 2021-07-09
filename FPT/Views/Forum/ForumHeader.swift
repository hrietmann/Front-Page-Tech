//
//  ForumHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit

struct ForumHeader: View {
    private let iconSize: CGFloat = 20
    @State private var presentUnderConstruction = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Forum".uppercased())
                    .font(.title.weight(.black).italic())
                    .padding(20)
                Spacer()
                
                HStack(spacing: 30) {
                    SeachHeaderButton()
                    
                    Button(action: {
                        presentUnderConstruction.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    }
                    
                    AccountView()
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
            .overlay(filter)
            
            Divider()
        }
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
    
    var filter: some View {
        Button(action: { presentUnderConstruction.toggle() }, label: {
        Image(systemName: "line.3.horizontal.decrease")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(Color(UIColor.tertiaryLabel))
    })
            .buttonStyle(BounceButtonStyle())
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct ForumHeader_Previews: PreviewProvider {
    static var previews: some View {
        ForumHeader()
    }
}
