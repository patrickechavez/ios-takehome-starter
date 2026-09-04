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
                Text(viewModel.message)
                    .font(Theme.Font.secondary)
                    .foregroundStyle(Theme.Color.secondaryText)
            }

            Button("Go to Second") {
                path.append(.second)
            }

            Button("Back") {
                path.removeLast()
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
