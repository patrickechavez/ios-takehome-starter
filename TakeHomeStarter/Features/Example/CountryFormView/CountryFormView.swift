//
//  CountryFormView.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct CountryFormView: View {

    @State private var viewModel: CountryFormViewModel
    @Binding var path: [Route]

    init(viewModel: CountryFormViewModel, path: Binding<[Route]>) {
        _viewModel = State(wrappedValue: viewModel)
        _path = path
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .loaded, .empty:
                form

            case let .failed(error):
                ErrorStateView(error: error, retry: { await viewModel.load() })
            }
        }
        .navigationTitle("Details")
        .task {
            guard viewModel.state.needsLoad else { return }
            await viewModel.load()
        }
    }

    private var form: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                AppTextField(
                    text: $viewModel.name,
                    placeholder: "Name",
                    label: "Name",
                    error: viewModel.nameError,
                    isRequired: true,
                    capitalization: .words
                )

                DateField(
                    label: "Birth date",
                    date: $viewModel.birthDate,
                    range: Date.distantPast...Date()
                )

                PickerField(
                    label: "Region",
                    placeholder: "Select your region",
                    items: viewModel.regions,
                    selection: $viewModel.region,
                    title: { $0 },
                    error: viewModel.regionError,
                    isRequired: true
                )
                .onChange(of: viewModel.region) { _, _ in
                    viewModel.regionChanged()
                }

                PickerField(
                    label: "Country",
                    placeholder: "Select your country",
                    items: viewModel.countriesInRegion,
                    selection: $viewModel.country,
                    title: \.name,
                    error: viewModel.countryError,
                    isRequired: true,
                    isEnabled: viewModel.region != nil
                )

                HStack(spacing: Theme.Spacing.md) {
                    Button {
                        guard let result = viewModel.submit() else { return }
                        path.append(.first(
                            name: result.name,
                            region: result.region,
                            country: result.country
                        ))
                    } label: {
                        Text("Submit").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.isValid)

                    Button {
                        viewModel.clear()
                    } label: {
                        Text("Clear").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .controlSize(.large)
                .padding(.top, Theme.Spacing.md)
            }
            .padding(Theme.Spacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
