//
//  BounceButtonStyle.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import Foundation
import SwiftUI



struct BounceButtonStyle: ButtonStyle {
    
    let scale: CGFloat
    init(scale: CGFloat = 0.93) {
        self.scale = scale
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.spring())
    }
}


struct BounceButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Button")
        })
            .buttonStyle(BounceButtonStyle())
        .padding()
    }
}
