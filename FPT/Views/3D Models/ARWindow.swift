//
//  ARWindow.swift
//  FPT
//
//  Created by Hans Rietmann on 16/06/2021.
//

import SwiftUI
import RealityKit
import ARKit
//import FocusEntity
import Combine




class ARUIView: ARView {
    
    
//    private lazy var focus = FocusEntity(on: self, focus: .classic)
//    private var sceneUpdateListner: Cancellable? = nil
    var model: ModelEntity?
    var isPlaced: Bool = false
//    private let anchor = AnchorEntity(plane: .horizontal)
//
//
//    required init(frame frameRect: CGRect) {
//        super.init(frame: frameRect)
//        configure()
//
//        sceneUpdateListner = scene.subscribe(to: SceneEvents.Update.self, { event in
//            self.updateScene(for: self)
//        })
//    }
//
//    required init?(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//    }
//
//    private func configure() {
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]
//        session.run(config)
//        scene.addAnchor(anchor)
//    }
//
//    private func updateScene(for view: ARUIView) {
//        view.focus.isEnabled = model != nil
//        guard let model = model else { return }
//        if isPlaced { place(model) }
//        else { remove(model) }
//    }
//
//    private func place(_ model: ModelEntity) {
//        anchor.addChild(model)
//    }
//
//    private func remove(_ model: ModelEntity) {
//        anchor.removeChild(model)
//    }
    
    
}



struct ARWindow: UIViewRepresentable {
    
    @Binding var model: ModelEntity?
    @Binding var isPlaced: Bool
    
    func makeUIView(context: Context) -> ARUIView {
        let view = ARUIView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: ARUIView, context: Context) {
        uiView.model = model
        uiView.isPlaced = isPlaced
    }
}
