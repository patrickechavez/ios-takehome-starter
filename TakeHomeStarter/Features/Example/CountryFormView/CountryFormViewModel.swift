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
    var region: String?
    var country: Country?

    private(set) var submitted: Submission?

    struct Submission: Hashable {
        let name: String
        let region: String
        let country: String
    }

    private var didAttemptSubmit = false

    @ObservationIgnored private let repository: any CountryRepository

    init(repository: any CountryRepository) {
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

    var nameError: String? {
        guard didAttemptSubmit else { return nil }

        let trimmed = name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Name is required." }

        let allowed = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: "-'"))
        guard trimmed.unicodeScalars.allSatisfy(allowed.contains) else {
            return "Cannot contain numbers or special characters."
        }
        return nil
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
        nameError == nil && region != nil && country != nil
            && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func load() async {
        await perform { [repository] in
            try await repository.countries()
        }
    }

    func submit() {
        didAttemptSubmit = true

        guard isValid, let region, let country else { return }

        submitted = Submission(
            name: name.trimmingCharacters(in: .whitespaces),
            region: region,
            country: country.name
        )
    }

    func clear() {
        name = ""
        region = nil
        country = nil
        submitted = nil
        didAttemptSubmit = false
    }

    func regionChanged() {
        country = nil
    }
}
