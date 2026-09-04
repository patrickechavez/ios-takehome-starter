//
//  SecondScreen.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct SecondScreen: View {

    @State private var viewModel: SecondScreenViewModel
    @Binding var path: [Route]

    init(viewModel: SecondScreenViewModel, path: Binding<[Route]>) {
        _viewModel = State(wrappedValue: viewModel)
        _path = path
    }

    var body: some View {
        List {
            Section {
                Text(viewModel.message)
                    .font(Theme.Font.secondary)
                    .foregroundStyle(Theme.Color.secondaryText)
            }

            Button("Back") {
                path.removeLast()
            }

            Button("Back to Start") {
                path.removeAll()
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
