//
//  TimeInterval.swift
//  FPT
//
//  Created by Hans Rietmann on 28/06/2021.
//

import Foundation



extension TimeInterval {
    var duration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 3
        return formatter.string(from: self)!
    }
}
