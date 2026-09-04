//
//  APIError.swift
//  TakeHomeStarter
//

import Foundation

enum APIError: LocalizedError, Equatable {

    case offline
    case timedOut
    case cancelled
    case invalidResponse
    case decodingFailed(detail: String)

    /// Any non-2xx response. `message` is the server's text, when it sent one.
    case http(status: Int, message: String?)

    var errorDescription: String? {
        switch self {
        case .offline:
            "You appear to be offline."
        case .timedOut:
            "The request took too long."
        case .cancelled:
            "The request was cancelled."
        case .invalidResponse:
            "The server sent something unexpected."
        case let .decodingFailed(detail):
            "Could not read the response. \(detail)"
        case let .http(status, message):
            message ?? "The request failed (\(status))."
        }
    }

    /// Cancellation is a normal part of SwiftUI's lifecycle — a view going away
    /// mid-request is not something to show the user.
    var isUserFacing: Bool {
        self != .cancelled
    }

    /// Turns anything thrown into an APIError. One funnel for every catch block.
    static func classify(_ error: any Error) -> APIError {
        if let apiError = error as? APIError { return apiError }
        if error is CancellationError { return .cancelled }

        guard let urlError = error as? URLError else { return .invalidResponse }

        return switch urlError.code {
        case .notConnectedToInternet, .dataNotAllowed: .offline
        case .timedOut: .timedOut
        case .cancelled: .cancelled
        default: .invalidResponse
        }
    }
}
