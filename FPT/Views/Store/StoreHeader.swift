//
//  StoreHeader.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import ViewKit


struct StoreHeader: View {
    private let iconSize: CGFloat = 20
    @State private var presentUnderConstruction = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("Merch.".uppercased())
                    .font(.title.weight(.black).italic())
                    .padding(20)
                Spacer()
                
                HStack(spacing: 26) {
                    
                    SeachHeaderButton()
                    
                    Button(action: { presentUnderConstruction.toggle() }, label: {
                        Image(systemName: "shippingbox.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: iconSize, height: iconSize)
                            .padding(.vertical)
                    })
                    
                    AccountView()
                }
                .foregroundColor(Color(.label))
                .buttonStyle(BounceButtonStyle())
                .padding()
            }
            .frame(height: UIScreen.main.bounds.width * 0.2)
            .zIndex(-2)
            Divider()
        }
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
}

struct StoreHeader_Previews: PreviewProvider {
    static var previews: some View {
        StoreHeader()
    }
}
