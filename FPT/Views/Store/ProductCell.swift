//
//  ProductCell.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import Views


struct ProductCell: View {
    
    let product: Product
    @State private var presentNotWorking = false
    @Environment(\.openURL) var openURL
    @State private var showThanks = false
    
    var body: some View {
        Button(action: { presentNotWorking.toggle() }, label: {
            VStack(alignment: .leading) {
                
                Image(product.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        Text(product.price.price)
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .padding(8)
                            .background(Color(.systemBackground))
                            .shadow(radius: 10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    )
                    .alert(isPresented: $presentNotWorking) {
                        Alert(title: Text("No store for now"),
                              message: Text("To have the best shop experience on mobile, I need FAHPAHTAH teespring.com API access to integrate a complete 🚽 merch store. 😝"),
                              primaryButton: .default(Text("OK, I give you access 😎"), action: { openURL(URL(string: "https://twitter.com/messages/1449711853-1449711853?recipient_id=1449711853")!) }),
                              secondaryButton: .cancel(Text("Maybe, I should hire you 😏")) { showThanks.toggle() })
                    }
                
                Text(product.title.uppercased())
                    .font(.headline.italic())
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
        })
        .foregroundColor(Color(.label))
        .buttonStyle(BounceButtonStyle())
        .fullScreenCover(isPresented: $showThanks) {
            HireHansFeaturesView()
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: .list[0])
    }
}
