//
//  ActionState.swift
//  TakeHomeStarter
//

import Foundation

/// Runs a single user action — submit, save, send — and turns whatever is
/// thrown into something the form can show. For one-shot buttons; use
/// `LoadState` for screens that load content.
///
///     let result = await action.run { try await repository.submit(form) }
@Observable
@MainActor
final class ActionState {

    /// True while the action is in flight.
    private(set) var isRunning = false

    /// The last failure, reset on every new attempt.
    private(set) var error: APIError?

    var errorMessage: String? {
        error?.localizedDescription
    }

    func clear() {
        error = nil
    }

    /// Returns nil when one is already running or it failed — check `error`
    /// to tell the user why.
    @discardableResult
    func run<T>(_ operation: @Sendable () async throws -> T) async -> T? {
        guard !isRunning else { return nil }

        error = nil
        isRunning = true
        defer { isRunning = false }

        do {
            return try await operation()
        } catch {
            let apiError = APIError.classify(error)

            // A cancelled attempt is not an error worth showing.
            guard apiError.isUserFacing else { return nil }
            self.error = apiError
            return nil
        }
    }
}
