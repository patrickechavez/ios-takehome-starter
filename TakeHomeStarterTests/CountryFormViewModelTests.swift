//
//  CountryFormViewModelTests.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Testing
@testable import TakeHomeStarter

@MainActor
struct CountryFormViewModelTests {

    private let sample = [
        Country(name: "Japan", region: "Asia"),
        Country(name: "Malaysia", region: "Asia"),
        Country(name: "France", region: "Europe")
    ]

    private func makeViewModel() async -> CountryFormViewModel {
        let viewModel = CountryFormViewModel(repository: FakeCountryRepository(stub: sample))
        await viewModel.load()
        return viewModel
    }

    @Test func regionsAreUniqueAndSorted() async {
        let viewModel = await makeViewModel()
        #expect(viewModel.regions == ["Asia", "Europe"])
    }

    @Test func countriesAreFilteredByTheChosenRegion() async {
        let viewModel = await makeViewModel()
        viewModel.region = "Asia"

        #expect(viewModel.countriesInRegion.map(\.name) == ["Japan", "Malaysia"])
    }

    @Test func changingRegionClearsTheChosenCountry() async {
        let viewModel = await makeViewModel()
        viewModel.region = "Asia"
        viewModel.country = Country(name: "Japan", region: "Asia")

        viewModel.regionChanged()

        #expect(viewModel.country == nil)
    }

    @Test func noErrorsBeforeTheFirstSubmit() async {
        let viewModel = await makeViewModel()

        #expect(viewModel.nameError == nil)
        #expect(viewModel.regionError == nil)
        #expect(viewModel.countryError == nil)
    }

    @Test func emptyNameIsRejected() async {
        let viewModel = await makeViewModel()
        viewModel.submit()

        #expect(viewModel.nameError == "Name is required.")
    }

    @Test func nameWithNumbersIsRejected() async {
        let viewModel = await makeViewModel()
        viewModel.name = "Andre 3000"
        viewModel.submit()

        #expect(viewModel.nameError == "Cannot contain numbers or special characters.")
    }

    @Test func nameWithHyphenOrApostropheIsAllowed() async {
        let viewModel = await makeViewModel()
        viewModel.name = "Anne-Marie O'Brien"
        viewModel.submit()

        #expect(viewModel.nameError == nil)
    }

    @Test func missingRegionAndCountryAreReported() async {
        let viewModel = await makeViewModel()
        viewModel.name = "Raven"
        viewModel.submit()

        #expect(viewModel.regionError == "You must select a region.")
        #expect(viewModel.countryError == "You must select a country.")
    }

    @Test func submitDoesNothingWhileInvalid() async {
        let viewModel = await makeViewModel()
        viewModel.name = "Raven"
        viewModel.submit()

        #expect(viewModel.submitted == nil)
    }

    @Test func validFormProducesASubmission() async {
        let viewModel = await makeViewModel()
        viewModel.name = "  Raven  "
        viewModel.region = "Asia"
        viewModel.country = Country(name: "Japan", region: "Asia")

        viewModel.submit()

        #expect(viewModel.submitted == CountryFormViewModel.Submission(
            name: "Raven",
            region: "Asia",
            country: "Japan"
        ))
    }

    @Test func clearResetsEverything() async {
        let viewModel = await makeViewModel()
        viewModel.name = "Raven"
        viewModel.region = "Asia"
        viewModel.country = Country(name: "Japan", region: "Asia")
        viewModel.submit()

        viewModel.clear()

        #expect(viewModel.name.isEmpty)
        #expect(viewModel.region == nil)
        #expect(viewModel.country == nil)
        #expect(viewModel.submitted == nil)
        #expect(viewModel.nameError == nil)
    }
}

private struct FakeCountryRepository: CountryRepository {

    let stub: [Country]
    var error: APIError?

    func countries() async throws -> [Country] {
        if let error { throw error }
        return stub
    }
}
