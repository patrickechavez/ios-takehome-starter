//
//  APIClient.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

protocol APIClient: Sendable {
    func get<T: Decodable & Sendable>(_ path: String, query: [URLQueryItem]) async throws -> T
}

extension APIClient {

    func get<T: Decodable & Sendable>(_ path: String) async throws -> T {
        try await get(path, query: [])
    }
}

struct URLSessionAPIClient: APIClient {

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = APIConfig.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func get<T: Decodable & Sendable>(_ path: String, query: [URLQueryItem]) async throws -> T {
        let request = try makeRequest(path: path, query: query)

        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200..<300).contains(http.statusCode) else {
                throw APIError.http(status: http.statusCode, message: String(data: data, encoding: .utf8))
            }

            do {
                return try JSONDecoder.api.decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed(detail: "\(T.self): \(error)")
            }
        } catch {
            throw APIError.classify(error)
        }
    }

    private func makeRequest(path: String, query: [URLQueryItem]) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidResponse
        }

        if !query.isEmpty { components.queryItems = query }

        guard let url = components.url else { throw APIError.invalidResponse }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.timeoutInterval = APIConfig.timeout
        return request
    }
}
