//
//  WarningView.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import SwiftUI

struct WarningView: View {
    let text: LocalizedStringKey
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("⚠️")
                .font(.headline)
            Text(text)
                .font(.footnote.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray)
        }
        .padding(16)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct WarningView_Previews: PreviewProvider {
    static var previews: some View {
        WarningView(text: "Wraning descripiton here")
    }
}
