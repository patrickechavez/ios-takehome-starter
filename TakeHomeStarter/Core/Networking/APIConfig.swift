//
//  APIConfig.swift
//  TakeHomeStarter
//

import Foundation

/// Change the base URL here when an assessment gives you a different API.
enum APIConfig {

    static let baseURL = URL(string: "https://api.first.org/data/v1/")!

    static let timeout: TimeInterval = 20
}
