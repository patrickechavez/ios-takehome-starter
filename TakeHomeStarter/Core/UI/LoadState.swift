//
//  LoadState.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

enum LoadState<Value> {

    case idle
    case loading
    case loaded(Value)
    case empty
    case failed(APIError)

    var value: Value? {
        if case let .loaded(value) = self { return value }
        return nil
    }

    var needsLoad: Bool {
        if case .idle = self { return true }
        return false
    }

    static func from(_ value: Value, isEmpty: (Value) -> Bool) -> LoadState {
        isEmpty(value) ? .empty : .loaded(value)
    }
}

extension LoadState where Value: Collection {

    static func from(_ value: Value) -> LoadState {
        value.isEmpty ? .empty : .loaded(value)
    }
}

@MainActor
protocol LoadableViewModel: AnyObject {

    associatedtype Value

    var state: LoadState<Value> { get set }
}

extension LoadableViewModel {

    func perform(
        isEmpty: @escaping (Value) -> Bool = { _ in false },
        _ operation: @Sendable () async throws -> Value
    ) async {
        if state.value == nil { state = .loading }

        do {
            let newValue = try await operation()
            try Task.checkCancellation()
            state = .from(newValue, isEmpty: isEmpty)
        } catch {
            fail(with: error)
        }
    }

    func fail(with error: any Error) {
        let apiError = APIError.classify(error)

        if apiError == .cancelled {
            state = .idle
            return
        }

        state = .failed(apiError)
    }
}

extension LoadableViewModel where Value: Collection {

    func perform(_ operation: @Sendable () async throws -> Value) async {
        await perform(isEmpty: { $0.isEmpty }, operation)
    }
}
