//
//  Model3DManager.swift
//  FPT
//
//  Created by Hans Rietmann on 16/06/2021.
//

import Foundation
import Combine
import RealityKit



class Model3DManager: ObservableObject {
    
    
    let model: Model
    @Published private(set) var result: Result<ModelEntity, Swift.Error>? = .none
    @Published var loadedModel: ModelEntity? = .none
    @Published var isPlaced = false
    private var modelLoadLisnter: AnyCancellable? = nil
    
    
    init(model: Model) {
        self.model = model
        load3DModel()
    }
    deinit {
        modelLoadLisnter?.cancel()
    }
    
    
    private func load3DModel() {
        guard let file = model.usdzFile else { return }
        modelLoadLisnter = ModelEntity.loadModelAsync(named: file)
            .sink { completion in
                switch completion {
                case .failure(let error): self.result = .failure(error)
                case .finished: return
                }
            } receiveValue: { entity in
                self.result = .success(entity)
                self.loadedModel = entity
                self.loadedModel?.scale *= self.model.scale
            }

    }
    
    
}
