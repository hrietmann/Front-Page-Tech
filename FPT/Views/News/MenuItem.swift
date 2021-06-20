//
//  MenuItem.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI




struct MenuItem: View {
    
    let menu: Menu
    @Binding var selected: Menu
    
    var body: some View {
        Button(action: { selected = menu }) {
            Text(menu.title.uppercased())
                .font(.title3.weight(.heavy).italic())
                .frame(height: UIScreen.main.bounds.width * 0.2)
                .overlay(
                    Rectangle()
                        .foregroundColor(.pink)
                        .frame(height: 4)
                        .frame(maxWidth: selected.id == menu.id ? .infinity:0, maxHeight: .infinity, alignment: .bottomLeading)
                        .animation(.easeOut)
                        .offset(y: -18)
                )
                .rotated()
        }
        .foregroundColor(Color(.label))
    }
}

struct MenuItem_Previews: PreviewProvider {
    static var previews: some View {
        MenuItem(menu: Menu.list[0], selected: .constant(Menu.list[0]))
    }
}
