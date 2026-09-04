//
//  APIConfig.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

enum APIConfig {

    static let baseURL: URL = {
        guard let value = string("API_BASE_URL"), let url = URL(string: value) else {
            preconditionFailure(
                """
                API_BASE_URL is missing or invalid in Info.plist.
                Set it in Config/<Environment>.xcconfig — remember to escape the \
                double slash as `https:/$()/example.com`.
                """
            )
        }
        return url
    }()

    static let timeout: TimeInterval = double("API_TIMEOUT_SECONDS") ?? 20

    private static func string(_ key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func double(_ key: String) -> Double? {
        string(key).flatMap(Double.init)
    }
}
