//
//  LeakView.swift
//  FPT
//
//  Created by Hans Rietmann on 14/06/2021.
//

import SwiftUI

struct LeakView: View {
    var body: some View {
        UnderConstructionView(closeButton: false)
    }
}

struct LeakView_Previews: PreviewProvider {
    static var previews: some View {
        LeakView()
    }
}
