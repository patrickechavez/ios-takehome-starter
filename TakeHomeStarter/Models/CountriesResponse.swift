//
//  CountriesResponse.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation

struct CountriesResponse: Decodable {

    let data: [String: Entry]

    struct Entry: Decodable {
        let country: String
        let region: String?
    }
}
