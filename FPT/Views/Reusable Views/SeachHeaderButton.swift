//
//  SeachHeaderButton.swift
//  FPT
//
//  Created by Hans Rietmann on 24/06/2021.
//

import SwiftUI

struct SeachHeaderButton: View {
    
    let color: Color
    @State private var presentSearchWorkInProgress = false
    
    init(color: Color = Color(.label)) {
        self.color = color
    }
    
    var body: some View {
        Button(action: { presentSearchWorkInProgress.toggle() }) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(.vertical)
        }
        .foregroundColor(color)
        .alert(isPresented: $presentSearchWorkInProgress, content: {
            Alert(title: Text("Impossible ☹️"), message: Text("You can't search for Jon eyebrows in this version. 🥸 (Or anything else for that matter)"), dismissButton: .cancel(Text("🚽")))
        })
    }
}

struct SeachHeaderButton_Previews: PreviewProvider {
    static var previews: some View {
        SeachHeaderButton()
    }
}
