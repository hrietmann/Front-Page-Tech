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
    let videosFiles: [String]
    let images: [String]
    let usdzFile: String?
    let scale: Float
    let creator: String
    let date: Date
    
    static let list: [Model] = [
        .init(title: "iPhone 13 Pro Bronze",
              videosFiles: [],
              images: ["iPhone 13 Pro Bronze 1", "iPhone 13 Pro Bronze 2", "iPhone 13 Pro Bronze 3"],
              usdzFile: "iPhone 13 Pro Bronze.usdz",
              scale: 1,
              creator: Model.creator,
              date: Date.string("20-06-2021")),
        .init(title: "iPhone 13",
              videosFiles: [],
              images: ["iPhone 13 1", "iPhone 13 2", "iPhone 13 3", "iPhone 13 4", "iPhone 13 5", "iPhone 13 6"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("10-06-2021")),
        .init(title: "iPad Mini",
              videosFiles: [],
              images: ["iPad Mini 1", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4", "iPad Mini 5", "iPad Mini 6", "iPad Mini 7", "iPad Mini 8"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("01-06-2021")),
        .init(title: "Mac mini",
              videosFiles: [],
              images: ["Mac mini 1", "Mac mini 2", "Mac mini 3", "Mac mini 4", "Mac mini 5", "Mac mini 6", "Mac mini 7"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("20-05-2021")),
        .init(title: "Apple Watch Series 7",
              videosFiles: [],
              images: ["Apple Watch Series 7 1", "Apple Watch Series 7 2", "Apple Watch Series 7 3", "Apple Watch Series 7 4", "Apple Watch Series 7 5", "Apple Watch Series 7 6", "Apple Watch Series 7 7"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("10-05-2021")),
        .init(title: "Google Pixel 6 and 6 Pro",
              videosFiles: [],
              images: ["Google Pixel 6 and 6 Pro 1", "Google Pixel 6 and 6 Pro 2", "Google Pixel 6 and 6 Pro 3", "Google Pixel 6 and 6 Pro 4", "Google Pixel 6 and 6 Pro 5", "Google Pixel 6 and 6 Pro 6", "Google Pixel 6 and 6 Pro 7", "Google Pixel 6 and 6 Pro 8", "Google Pixel 6 and 6 Pro 9", "Google Pixel 6 and 6 Pro 10"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("01-05-2021")),
        .init(title: "Airpods Max",
              videosFiles: ["Airpods Max"],
              images: ["Airpods Max 1", "Airpods Max 2", "Airpods Max 3", "Airpods Max 4", "Airpods Max 5", "Airpods Max 6", "Airpods Max 7", "Airpods Max 8", "Airpods Max 9", "Airpods Max 10"],
              usdzFile: nil,
              scale: 1,
              creator: Model.creator,
              date: Date.string("20-04-2021")),
    ]
    
    fileprivate static let creator = "Ian Zelbo"
    
}
