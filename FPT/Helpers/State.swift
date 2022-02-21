//
//  State.swift
//  FPT
//
//  Created by Hans Rietmann on 25/06/2021.
//

import Foundation




enum ManagerState<Result: Equatable>: Equatable {
    case waiting
    case loading
    case failure(error: FPTError)
    case success(result: Result)
    
    var error: FPTError? {
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
    
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if let error = lhs.error, error == rhs.error { return true }
        if let result = lhs.result, result == rhs.result { return true }
        if lhs.isWaiting, rhs.isWaiting { return true }
        if lhs.isLoading, rhs.isLoading { return true }
        return false
    }
}
