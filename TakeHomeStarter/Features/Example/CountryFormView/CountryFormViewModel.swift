//
//  CountryFormViewModel.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation
import Observation

@Observable
@MainActor
final class CountryFormViewModel: LoadableViewModel {

    var state: LoadState<[Country]> = .idle

    var name = ""
    var birthDate: Date?
    var region: String?
    var country: Country?

    private var didAttemptSubmit = false

    @ObservationIgnored private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    var regions: [String] {
        guard let countries = state.value else { return [] }
        return Set(countries.map(\.region)).sorted()
    }

    var countriesInRegion: [Country] {
        guard let countries = state.value, let region else { return [] }
        return countries.filter { $0.region == region }
    }

    private var nameValidationMessage: String? {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Name is required." }

        let allowed = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: "-'"))
        guard trimmed.unicodeScalars.allSatisfy(allowed.contains) else {
            return "Cannot contain numbers or special characters."
        }
        return nil
    }

    var nameError: String? {
        guard didAttemptSubmit else { return nil }
        return nameValidationMessage
    }

    var regionError: String? {
        guard didAttemptSubmit, region == nil else { return nil }
        return "You must select a region."
    }

    var countryError: String? {
        guard didAttemptSubmit, country == nil else { return nil }
        return "You must select a country."
    }

    var isValid: Bool {
        nameValidationMessage == nil && region != nil && country != nil
    }

    func load() async {
        await perform { [repository] in
            try await repository.countries()
        }
    }

    func submit() -> (name: String, region: String, country: String)? {
        didAttemptSubmit = true

        guard isValid, let region, let country else { return nil }

        return (
            name: name.trimmingCharacters(in: .whitespaces),
            region: region,
            country: country.name
        )
    }

    func clear() {
        name = ""
        region = nil
        country = nil
        didAttemptSubmit = false
    }

    func regionChanged() {
        country = nil
    }
}
