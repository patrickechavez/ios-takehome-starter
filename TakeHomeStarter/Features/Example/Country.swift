//
//  Country.swift
//  TakeHomeStarter
//

import Foundation

struct Country: Hashable, Sendable {
    let name: String
    let region: String
}

// MARK: - API shape
//
// https://api.first.org/data/v1/countries?limit=300 returns countries keyed by
// ISO code, so the response is a dictionary rather than an array:
//
//     { "data": { "DZ": { "country": "Algeria", "region": "Africa" }, ... } }

private struct CountriesResponse: Decodable {
    let data: [String: Entry]

    struct Entry: Decodable {
        let country: String
        let region: String?
    }
}

// MARK: - Repository

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
