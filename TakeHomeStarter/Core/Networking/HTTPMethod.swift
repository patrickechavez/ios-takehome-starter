//
//  HTTPMethod.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

enum HTTPMethod: String, Sendable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
