//
//  Model3DCell.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import SwiftUI
import SceneKit
import ViewKit


struct Model3DCell: View {
    
    let model: Model
    @State private var presentModel = false
    @State private var pressentMissingARAlert = false
    @State private var showImage = true
    @State private var presentUnderConstruction = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            imageThumbnail
            footer
            Divider()
        }
        .animation(.spring())
        .buttonStyle(BounceButtonStyle())
        .sheet(isPresented: $presentUnderConstruction) {
            UnderConstructionView(closeButton: true)
        }
    }
    
    var imageThumbnail: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(model.images, id: \.self) {
                    Image($0)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .aspectRatio(0.8, contentMode: .fill)
            .opacity(showImage ? 1:0)
        .scaleEffect(showImage ? 1:1.3)
            .overlay(modelThumbnail)
            .overlay(ARKitButton)
            .overlay(thumbnailButton)
    }
    
    var icon: String? {
        if #available(iOS 15, *) {
            return model.usdzFile == nil ? "arkit.badge.xmark" : "arkit"
        } else {
            return model.usdzFile == nil ? nil : "arkit"
        }
    }
    
    @ViewBuilder
    var ARKitButton: some View {
        if let icon = icon {
            Button(action: {
                if model.usdzFile == nil {
                    pressentMissingARAlert.toggle()
                } else {
                    presentModel.toggle()
                }
            }, label: {
                Image(systemName: icon)
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
                .alert(isPresented: $pressentMissingARAlert) {
                    Alert(title: Text("Sorry man…"),
                          message: Text("There's no 3D model given for this render."),
                          dismissButton: .cancel(Text("Not cool 😢")))
                }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var thumbnailButton: some View {
        if model.usdzFile != nil {
            Button(action: { showImage.toggle() }) {
                Image(systemName: showImage ? "cube.fill":"photo.fill")
                    .font(.body)
                    .padding(10)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(Circle())
            }
            .padding(18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var modelThumbnail: some View {
        if let file = model.usdzFile {
            SceneView(scene: SCNScene(named: file), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                .opacity(!showImage ? 1:0)
                .scaleEffect(!showImage ? 1:1.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            EmptyView()
        }
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
            
            Button(action: { presentUnderConstruction.toggle() }, label: {
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
        Image("iPhone 13 1")
//        Model3DCell(model: .list[0])
    }
}
