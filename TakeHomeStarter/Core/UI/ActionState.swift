//
//  ActionState.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

@Observable
@MainActor
final class ActionState {

    private(set) var isRunning = false

    private(set) var error: APIError?

    var errorMessage: String? {
        error?.localizedDescription
    }

    func clear() {
        error = nil
    }

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

            guard apiError.isUserFacing else { return nil }
            self.error = apiError
            return nil
        }
    }
}
