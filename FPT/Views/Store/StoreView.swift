//
//  StoreView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct StoreView: View {
    
    let columns = [
        GridItem(.flexible(), alignment: .topLeading),
        GridItem(.flexible(), alignment: .topLeading)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            StoreHeader()
            ErrorView(title: "Empty shelves 🤭", error: "We may or may not be preparing some new merch. maybe. maybenot.", action: nil)
                .padding()
//            ScrollView(showsIndicators: false) {
//                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
//                    ForEach(Product.list) { product in
//                        ProductCell(product: product)
//                    }
//                }
//                .padding()
//            }
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
