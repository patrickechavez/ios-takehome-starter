//
//  AppDependencies.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

@MainActor
final class AppDependencies {

    private let countryRepository: CountryRepository

    init(countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }

    static func live() -> AppDependencies {
        AppDependencies(countryRepository: RemoteCountryRepository(api: URLSessionAPIClient()))
    }

    func makeCountryFormViewModel() -> CountryFormViewModel {
        CountryFormViewModel(repository: countryRepository)
    }

    func makeFirstScreenViewModel(
        name: String,
        region: String,
        country: String
    ) -> FirstScreenViewModel {
        FirstScreenViewModel(name: name, region: region, country: country)
    }

    func makeSecondScreenViewModel() -> SecondScreenViewModel {
        SecondScreenViewModel()
    }
}
