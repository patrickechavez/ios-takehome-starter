//
//  FirstScreenViewModel.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation
import Observation

@Observable
@MainActor
final class FirstScreenViewModel {

    let name: String
    let region: String
    let country: String

    init(name: String, region: String, country: String) {
        self.name = name
        self.region = region
        self.country = country
    }

    var greeting: String {
        "Hi \(name)"
    }

    var origin: String {
        "You are from \(region), \(country)"
    }
}
