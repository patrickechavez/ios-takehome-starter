//
//  APIError.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

enum APIError: LocalizedError, Equatable {

    case offline
    case timedOut
    case cancelled
    case invalidResponse
    case decodingFailed(detail: String)

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

    var isUserFacing: Bool {
        self != .cancelled
    }

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
