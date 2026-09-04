//
//  AppDependencies.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

@MainActor
final class AppDependencies {

    let api: any APIClient

    init(api: any APIClient = LiveAPIClient()) {
        self.api = api
    }

    func makeCountryFormViewModel() -> CountryFormViewModel {
        CountryFormViewModel(repository: LiveCountryRepository(api: api))
    }

    func makeFirstScreenViewModel() -> FirstScreenViewModel {
        FirstScreenViewModel()
    }

    func makeSecondScreenViewModel() -> SecondScreenViewModel {
        SecondScreenViewModel()
    }
}
