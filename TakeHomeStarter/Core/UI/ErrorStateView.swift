//
//  ErrorStateView.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct ErrorStateView: View {

    let error: APIError
    var retry: (@Sendable () async -> Void)?

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            if let retry {
                Button("Try Again") {
                    Task { await retry() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var title: String {
        switch error {
        case .offline: "You're offline"
        case .timedOut: "That took too long"
        default: "Something went wrong"
        }
    }

    private var icon: String {
        switch error {
        case .offline: "wifi.exclamationmark"
        case .timedOut: "clock.badge.exclamationmark"
        default: "exclamationmark.triangle"
        }
    }
}
