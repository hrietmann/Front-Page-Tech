//
//  ProductCell.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct ProductCell: View {
    
    let product: Product
    
    var body: some View {
        Button(action: {}, label: {
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
                
                Text(product.title.uppercased())
                    .font(.headline.italic())
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
        })
        .foregroundColor(Color(.label))
        .buttonStyle(BounceButtonStyle())
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: .list[0])
    }
}
