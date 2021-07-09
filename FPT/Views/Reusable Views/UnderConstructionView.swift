//
//  UnderConstructionView.swift
//  FPT
//
//  Created by Hans Rietmann on 26/06/2021.
//

import SwiftUI
import Views

struct UnderConstructionView: View {
    
    let closeButton: Bool
    @State private var appeared = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        Image("under_construction")
            .resizable()
            .offset(y: appeared ? 0:16)
            .opacity(appeared ? 1:0)
            .overlay(
                Text("under\nconstruction\n🚧🏗🚽".uppercased())
                    .font(.title2.italic())
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(20)
                    .background(Color(.tertiarySystemBackground))
                    .shadow(radius: 30, x: 6, y: 12)
                    .offset(y: appeared ? 0:32)
                    .opacity(appeared ? 1:0)
                    .animation(.spring().delay(0.6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            .ignoresSafeArea()
            .transition(.opacity)
            .animation(.spring(response: 0.4))
            .onAppear { appeared = true }
            .onDisappear { appeared = false }
            .overlay(close)
    }
    
    @ViewBuilder
    var close: some View {
        if closeButton {
            Button(action: { presentation.wrappedValue.dismiss() }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline.bold())
                    .padding(8)
                    .foregroundColor(.secondary)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Circle())
            })
                .ignoresSafeArea()
                .buttonStyle(BounceButtonStyle())
                .shadow(radius: 8)
                .padding()
                .padding(.top, UIApplication.shared.windows[0].safeAreaInsets.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        } else {
            EmptyView()
        }
    }
}

struct UnderConstructionView_Previews: PreviewProvider {
    static var previews: some View {
        UnderConstructionView(closeButton: true)
    }
}
