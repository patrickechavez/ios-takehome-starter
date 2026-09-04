//
//  AppDependencies.swift
//  TakeHomeStarter
//

import Foundation

/// Everything the app needs, built in one place. Views get view models from
/// here, so tests and previews can hand in a fake API client instead.
@MainActor
final class AppDependencies {

    let api: any APIClient

    init(api: any APIClient = LiveAPIClient()) {
        self.api = api
    }

    func makeCountryFormViewModel() -> CountryFormViewModel {
        CountryFormViewModel(repository: LiveCountryRepository(api: api))
    }
}
