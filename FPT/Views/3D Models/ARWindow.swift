//
//  ARWindow.swift
//  FPT
//
//  Created by Hans Rietmann on 16/06/2021.
//

//#if !targetEnvironment(simulator)
// https://github.com/maxxfrazer/FocusEntity
//import FocusEntity
//#endif
import SwiftUI
import RealityKit
import ARKit
import Combine




class ARUIView: ARView {
    
    
//    #if !targetEnvironment(simulator)
//    private lazy var focus: FocusEntity = {
//        var focus = FocusEntity(on: self, style: .classic(color: .white))
////        focus.viewDelegate = self
//        return focus
//    }()
//    #endif
    private var sceneUpdateListner: Cancellable? = nil
    var model: ModelEntity?
    var isPlaced: Bool = false


    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        configure()

        sceneUpdateListner = scene.subscribe(to: SceneEvents.Update.self, { event in
            self.updateScene(for: self)
        })
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        #if !targetEnvironment(simulator)
        session.run(config)
        #endif
    }

    private func updateScene(for view: ARUIView) {
       
//        #if !targetEnvironment(simulator)
//        view.focus.isEnabled = model != nil
//        #endif
        guard let model = model else { return }
        if isPlaced { place(model) }
        else { remove(model) }
    }

    private func place(_ model: ModelEntity) {
        #if !targetEnvironment(simulator)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        scene.addAnchor(anchor)
        #endif
        DispatchQueue.main.async {
            self.model = nil
        }
    }

    private func remove(_ model: ModelEntity) {
        scene.anchors.forEach { scene.removeAnchor($0) }
    }
    
    
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
