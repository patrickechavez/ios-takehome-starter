//
//  RootView.swift
//  TakeHomeStarter
//

import SwiftUI

/// Point this at whatever the assessment asks for. The example below is a
/// worked reference — delete `Features/Example` once you have your own screen.
struct RootView: View {

    let dependencies: AppDependencies

    var body: some View {
        NavigationStack {
            CountryFormView(viewModel: dependencies.makeCountryFormViewModel())
        }
    }
}
