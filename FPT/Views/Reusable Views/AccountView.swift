//
//  AccountView.swift
//  FPT
//
//  Created by Hans Rietmann on 24/06/2021.
//

import SwiftUI

struct AccountView: View {
    
    @State private var presentAccountWorkInProgress = false
    
    var body: some View {
        Button(action: { presentAccountWorkInProgress.toggle() }) {
            Image("john")
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        }
        .alert(isPresented: $presentAccountWorkInProgress, content: {
            Alert(title: Text("Stop 🛑"), message: Text("This space is under construction ! 🚧 Come back in a later version 👷🏽‍♂️"), dismissButton: .cancel(Text("🧻🧻🧻")))
        })
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
