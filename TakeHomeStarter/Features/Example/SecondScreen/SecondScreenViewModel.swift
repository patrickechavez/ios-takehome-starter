//
//  SecondScreenViewModel.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import Foundation
import Observation

@Observable
@MainActor
final class SecondScreenViewModel {

    let title = "Second Screen"
    let message = "Back pops one screen. Back to Start empties the whole stack."
}
