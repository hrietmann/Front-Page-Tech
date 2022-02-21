//
//  ImageColors.swift
//  FPT
//
//  Created by Hans Rietmann on 09/02/2022.
//

import SwiftUI

struct ImageColors {
    public var background: Color!
    public var primary: Color!
    public var secondary: Color!
    public var detail: Color!
    
    public init(background: Color, primary: Color, secondary: Color, detail: Color) {
        self.background = background
        self.primary = primary
        self.secondary = secondary
        self.detail = detail
    }
}
