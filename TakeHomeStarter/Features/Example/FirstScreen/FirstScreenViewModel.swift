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

    let title = "First Screen"
    let message = "Pushed onto the stack after the form was submitted."
}
