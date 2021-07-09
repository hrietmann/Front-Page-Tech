//
//  State.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation




enum ManagerState<Result> {
    case waiting
    case loading
    case failure(error: Error)
    case success(result: Result)
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        } else { return nil }
    }
    
    var result: Result? {
        if case .success(let result) = self {
            return result
        } else { return nil }
    }
    
    var isWaiting: Bool {
        if case .waiting = self { return true }
        else { return false }
    }
    
    var isLoading: Bool {
        if case .loading = self { return true }
        else { return false }
    }
    
    var isWaitingOrLoading: Bool {
        return isWaiting || isLoading
    }
}
