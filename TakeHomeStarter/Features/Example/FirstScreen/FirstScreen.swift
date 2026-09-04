//
//  FirstScreen.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct FirstScreen: View {

    @State private var viewModel: FirstScreenViewModel
    @Binding var path: [Route]

    init(viewModel: FirstScreenViewModel, path: Binding<[Route]>) {
        _viewModel = State(wrappedValue: viewModel)
        _path = path
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text(viewModel.greeting)
                        .font(Theme.Font.sectionTitle)

                    Text(viewModel.origin)
                        .font(Theme.Font.body)
                        .foregroundStyle(Theme.Color.secondaryText)
                }
                .padding(.vertical, Theme.Spacing.xs)
            }

            Button("Go to Second") {
                path.append(.second)
            }

            Button("Back") {
                path.removeLast()
            }
        }
        .navigationTitle("First Screen")
        .navigationBarTitleDisplayMode(.inline)
    }
}
