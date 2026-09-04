//
//  CountryRepository.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

protocol CountryRepository: Sendable {
    func countries() async throws -> [Country]
}

struct LiveCountryRepository: CountryRepository {

    private let api: any APIClient

    init(api: any APIClient) {
        self.api = api
    }

    func countries() async throws -> [Country] {
        let response: CountriesResponse = try await api.get(
            "countries",
            query: [URLQueryItem(name: "limit", value: "300")]
        )

        return response.data.values
            .compactMap { entry in
                guard let region = entry.region, !region.isEmpty else { return nil }
                return Country(name: entry.country, region: region)
            }
            .sorted { $0.name < $1.name }
    }
}
