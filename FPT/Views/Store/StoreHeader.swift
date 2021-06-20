//
//  StoreHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct StoreHeader: View {
    private let iconSize: CGFloat = 20
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Merch.".uppercased())
                    .font(.title.weight(.black).italic())
                    .padding(20)
                Spacer()
                
                HStack(spacing: 26) {
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    }
                    
                    Button(action: {}, label: {
                        Image(systemName: "shippingbox.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    })
                    
                    Button(action: {}) {
                        Image("john")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                }
                .foregroundColor(Color(.label))
                .buttonStyle(BounceButtonStyle())
                .padding()
            }
            .frame(height: UIScreen.main.bounds.width * 0.2)
            .zIndex(-2)
            Divider()
        }
    }
}

struct StoreHeader_Previews: PreviewProvider {
    static var previews: some View {
        StoreHeader()
    }
}
