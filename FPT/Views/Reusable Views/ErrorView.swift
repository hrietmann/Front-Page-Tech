//
//  ErrorView.swift
//  FPT
//
//  Created by Hans Rietmann on 27/01/2022.
//

import SwiftUI

struct ErrorView: View {
    
    let title: String
    let error: String
    struct Action {
        let title: String
        let completion: () -> ()
        
        init(title: String = "Get an other try", completion: @escaping () -> ()) {
            self.title = title
            self.completion = completion
        }
    }
    let action: Action?
    
    init(title: String? = nil, error: String, action: (() -> Action)?) {
        self.title = title ?? ["Oh, oh...", "🚽 problem!", "End of the show", "Well.. uh.", "Error ?! 🥸"].randomElement()!
        self.error = error
        self.action = action?()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title3.italic())
                .fontWeight(.heavy)
                .textCase(.uppercase)
            Text(error)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            if let action = action {
                Button(action: action.completion) {
                    Text(action.title)
                        .padding(12)
                        .foregroundColor(.white)
                        .font(.subheadline.italic().weight(.heavy))
                        .textCase(.uppercase)
                        .lineLimit(1)
                }
                .background(.tint)
                .padding(.top)
            }
        }
        .padding()
        .padding()
        .background(Color(.tertiarySystemBackground))
        .shadow(color: .secondary.opacity(0.2), radius: 10, x: 4, y: 8)
        .transition(.opacity.combined(with: .offset(y: 16)))
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: "Unespected error.") { .init() {} }
        .preferredColorScheme(.dark)
    }
}
