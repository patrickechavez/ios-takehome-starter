//
//  RootView.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct RootView: View {

    let dependencies: AppDependencies

    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            CountryFormView(
                viewModel: dependencies.makeCountryFormViewModel(),
                path: $path
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .first:
                    FirstScreen(
                        viewModel: dependencies.makeFirstScreenViewModel(),
                        path: $path
                    )

                case .second:
                    SecondScreen(
                        viewModel: dependencies.makeSecondScreenViewModel(),
                        path: $path
                    )
                }
            }
        }
    }
}
