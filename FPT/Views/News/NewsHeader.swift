//
//  NewsHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI

struct NewsHeader: View {
    private let iconSize: CGFloat = 20
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .leading)
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
                    
                    Button(action: {}, label: {
                        Image(systemName: "bell.badge.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    })
                    .foregroundColor(Color(.label))
                    
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
            
            Text("A Dumb Tech News App For Smart People.".uppercased())
                .font(.caption)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pink)
                .zIndex(-1)
        }
    }
}

struct HomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        NewsHeader()
    }
}
