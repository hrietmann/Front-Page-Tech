//
//  File.swift
//  FPT
//
//  Created by Hans Rietmann on 03/02/2022.
//

import Foundation



struct UserNotSignedIn: LocalizedError {
    let goal: String
    var errorDescription: String? { "Dude, you need to be connected to " + goal }
}
