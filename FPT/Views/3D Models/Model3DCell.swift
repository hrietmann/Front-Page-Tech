//
//  Model3DCell.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import SceneKit


struct Model3DCell: View {
    
    let model: Model
    @State private var presentModel = false
    @State private var showImage = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            imageThumbnail
            footer
            Divider()
        }
        .animation(.spring())
        .buttonStyle(BounceButtonStyle())
    }
    
    var imageThumbnail: some View {
        Image(model.image)
            .resizable()
            .scaledToFit()
            .opacity(showImage ? 1:0)
            .scaleEffect(showImage ? 1:1.3)
            .overlay(modelThumbnail)
            .overlay(ARKitButton)
            .overlay(thumbnailButton)
    }
    
    var ARKitButton: some View {
        Button(action: { presentModel.toggle() }, label: {
            Image(systemName: "arkit")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.pink)
                .clipShape(Circle())
                .shadow(color: .pink.opacity(0.4), radius: 10, x: 2, y: 5)
        })
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .sheet(isPresented: $presentModel) {
                Model3DView(model: model)
            }
    }
    
    var thumbnailButton: some View {
        Button(action: { showImage.toggle() }) {
            Image(systemName: showImage ? "cube.fill":"photo.fill")
                .font(.body)
                .padding(10)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Circle())
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    var modelThumbnail: some View {
        SceneView(scene: SCNScene(named: model.file), options: [.autoenablesDefaultLighting, .allowsCameraControl])
            .opacity(!showImage ? 1:0)
            .scaleEffect(!showImage ? 1:1.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    var footer: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title.uppercased())
                    .font(.title2.italic())
                    .fontWeight(.heavy)
                    .foregroundColor(Color(.label))
                Text("By \(model.creator)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.secondary)
                Text(model.date.timeAgo)
                    .font(.caption)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            
            Spacer()
            
            Button(action: {}, label: {
                Image(systemName: "icloud.and.arrow.down.fill")
                    .font(.footnote)
                    .foregroundColor(.pink)
                    .padding(10)
                    .background(Color(.tertiarySystemFill))
                    .clipShape(Circle())
            })
        }
        .padding(.horizontal)
    }
}

struct Model3DCell_Previews: PreviewProvider {
    static var previews: some View {
        Model3DCell(model: .list[0])
    }
}
