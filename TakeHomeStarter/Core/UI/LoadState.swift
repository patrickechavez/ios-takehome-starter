//
//  LoadState.swift
//  TakeHomeStarter
//

import Foundation

/// The four states any screen that loads something can be in.
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

// MARK: - Loading and failing

/// View models that load content conform to this and call `perform` instead of
/// hand-writing do/catch blocks.
@MainActor
protocol LoadableViewModel: AnyObject {

    associatedtype Value

    var state: LoadState<Value> { get set }
}

extension LoadableViewModel {

    /// Runs `operation` and moves `state` through `.loading` to `.loaded`,
    /// `.empty`, or `.failed`.
    ///
    /// Named `perform`, not `load`, so it never shadows a view model's own
    /// `load()` — that overlap reads like recursion, and becomes recursion
    /// if the closure is ever left off.
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

        // A cancelled load goes back to `.idle` so the view can try again.
        if apiError == .cancelled {
            state = .idle
            return
        }

        state = .failed(apiError)
    }
}

extension LoadableViewModel where Value: Collection {

    /// Same as `perform`, with empty results shown as `.empty`.
    func perform(_ operation: @Sendable () async throws -> Value) async {
        await perform(isEmpty: { $0.isEmpty }, operation)
    }
}
