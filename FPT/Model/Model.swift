//
//  Model.swift
//  FPT
//
//  Created by Hans Rietmann on 15/06/2021.
//

import Foundation



struct Model: Identifiable {
    
    let id = UUID()
    let title: String
    let image: String
    let file: String
    let scale: Float
    let creator: String
    let date: Date
    
    static let list = [
        Model(title: "The all new iPad Mini", image: "model3", file: "ipad3Dmodel.usdz", scale: 0.07, creator: "Ian Zelbo", date: Date.string("13-06-2021")),
        Model(title: "iPhone 13 based on CADs", image: "model2", file: "iphone3Dmodel.usdz", scale: 0.05, creator: "Ian Zelbo", date: Date.string("04-06-2021")),
        Model(title: "AirPods Max", image: "model4", file: "ipad3Dmodel.usdz", scale: 0.07, creator: "Ian Zelbo", date: Date.string("23-05-2021")),
        Model(title: "2021 MacBook Air Redesign", image: "model1", file: "ipad3Dmodel.usdz", scale: 0.07, creator: "Ian Zelbo", date: Date.string("10-05-2021")),
        Model(title: "iMac 24‘‘ Alternative Concept", image: "model5", file: "ipad3Dmodel.usdz", scale: 0.07, creator: "Ian Zelbo", date: Date.string("21-04-2021"))
    ]
    
}
