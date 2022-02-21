//
//  AsyncState.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import Foundation




enum AsyncState<Success> {
    
    
    case waiting
    case loading(Task<Success,Error>)
    case success(Success)
    case failure(Error)
    
    
    var value: Success? {
        switch self {
        case .success(let result): return result
        default: return nil
        }
    }
    var error: Error? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    var task: Task<Success,Error>? {
        switch self {
        case .loading(let task): return task
        default: return nil
        }
    }
    
    var isWaiting: Bool { !isLoading && !isSuccessfull && !isFailure }
    var isLoading: Bool { task != nil }
    var isDone: Bool { !isLoading }
    var isSuccessfull: Bool { value != nil }
    var isFailure: Bool { error != nil }
    
    
}
