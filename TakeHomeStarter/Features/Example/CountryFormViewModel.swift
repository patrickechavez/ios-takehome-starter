//
//  CountryFormViewModel.swift
//  TakeHomeStarter
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

    /// Set on submit so the view can push the result screen.
    private(set) var submitted: Submission?

    struct Submission: Hashable {
        let name: String
        let region: String
        let country: String
    }

    /// Errors only appear once the user has tried to submit, so the form
    /// doesn't shout at them while they're still filling it in.
    private var didAttemptSubmit = false

    @ObservationIgnored private let repository: any CountryRepository

    init(repository: any CountryRepository) {
        self.repository = repository
    }

    // MARK: - Derived lists

    /// Unique regions, alphabetical.
    var regions: [String] {
        guard let countries = state.value else { return [] }
        return Set(countries.map(\.region)).sorted()
    }

    /// Countries in the chosen region, alphabetical.
    var countriesInRegion: [Country] {
        guard let countries = state.value, let region else { return [] }
        return countries.filter { $0.region == region }
    }

    // MARK: - Validation

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

    // MARK: - Actions

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

    /// Picking a new region invalidates the country chosen under the old one.
    func regionChanged() {
        country = nil
    }
}
