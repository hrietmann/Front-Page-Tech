//
//  Job.swift
//  FPT
//
//  Created by Hans Rietmann on 07/02/2022.
//

import Foundation



actor Job<Success> {
    
    
    private var state: AsyncState<Success>
    
    
    var value: Success? { state.value }
    var error: Error? { state.error }
    var isWaiting: Bool { state.isWaiting }
    var isLoading: Bool { state.isLoading }
    var isDone: Bool { state.isDone }
    var isSuccessfull: Bool { state.isSuccessfull }
    var isFailure: Bool { state.isFailure }
    
    
    static var waits: Job<Success> { .init(state: .waiting) }
    static func loads(_ operation: @Sendable @escaping () async throws -> Success) -> Job<Success> {
        let task = Task(operation: operation)
        let job = Job<Success>.init(state: .loading(task))
        Task.detached {
            let result = await task.result
            await job.push(result)
        }
        return job
    }
    static func succeeded(with value: Success) -> Job<Success> { .init(state: .success(value)) }
    static func failed(with error: Error) -> Job<Success> { .init(state: .failure(error)) }
    static func ended(with result: Result<Success,Error>) -> Job<Success> {
        switch result {
        case .success(let success): return .succeeded(with: success)
        case .failure(let error): return .failed(with: error)
        }
    }
    static func ended(with result: @escaping () throws -> Success) -> Job<Success> {
        do { return .succeeded(with: try result()) }
        catch { return .failed(with: error) }
    }
    
    
    private init(state: AsyncState<Success>) { self.state = state }
    private func push(_ result: Result<Success,Swift.Error>) {
        switch result {
        case .success(let success): state = .success(success)
        case .failure(let error): state = .failure(error)
        }
    }
    
    
    deinit { state.task?.cancel() }
    
    
}
