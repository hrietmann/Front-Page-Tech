//
//  Model3DView.swift
//  FPT
//
//  Created by Hans Rietmann on 16/06/2021.
//

import SwiftUI


struct Model3DView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: Model3DManager
    
    init(model: Model) {
        self.manager = Model3DManager(model: model)
    }
    
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundColor(.white)
                .scaleEffect(manager.loadedModel == nil ? 1:0.7)
                .opacity(manager.loadedModel == nil ? 1:0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            ARWindow(model: $manager.loadedModel, isPlaced: $manager.isPlaced)
                .scaleEffect(manager.loadedModel != nil ? 1:1.3)
                .opacity(manager.loadedModel != nil ? 1:0)
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
        .background(Color.black)
        .overlay(header)
        .overlay(validateButton)
        .animation(.spring(response: 0.4))
    }
    
    var header: some View {
        HStack(alignment: .top) {
            Text(manager.model.title.uppercased())
                .font(.title2)
                .bold()
                .foregroundColor(Color(.systemBackground))
                .padding(32)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundColor(Color(.systemBackground))
                    .padding(32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
    
    var validateButton: some View {
        Button(action: { manager.isPlaced.toggle() }) {
            Image(systemName: manager.isPlaced ? "xmark" : "checkmark")
                .font(.title2.bold())
                .padding(24)
                .foregroundColor(manager.isPlaced ? .red : .green)
                .background(Color(.systemBackground))
                .clipShape(Circle())
        }
        .buttonStyle(BounceButtonStyle())
        .padding(32)
        .opacity(manager.loadedModel != nil ? 1:0)
        .transition(.slide)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct Model3DView_Previews: PreviewProvider {
    static var previews: some View {
        Model3DView(model: .list[0])
    }
}
