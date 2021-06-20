//
//  Models3DView.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI

struct Models3DView: View {
    var body: some View {
        VStack(spacing: 0) {
            Models3DHeader()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Model.list) { model in
                        Model3DCell(model: model)
                    }
                }
            }
        }
    }
}

struct Models3DView_Previews: PreviewProvider {
    static var previews: some View {
        Models3DView()
    }
}
