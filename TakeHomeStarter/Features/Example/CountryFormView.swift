//
//  CountryFormView.swift
//  TakeHomeStarter
//

import SwiftUI

struct CountryFormView: View {

    @State private var viewModel: CountryFormViewModel

    init(viewModel: CountryFormViewModel) {
        _viewModel = State(wrappedValue: viewModel)
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
        .navigationDestination(item: submissionBinding) { submission in
            ResultView(submission: submission)
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

                PickerField(
                    label: "Region",
                    placeholder: "Select your region",
                    items: viewModel.regions,
                    selection: $viewModel.region,
                    title: { $0 },
                    error: viewModel.regionError
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
                    isEnabled: viewModel.region != nil
                )

                HStack(spacing: Theme.Spacing.md) {
                    Button("Submit") { viewModel.submit() }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)

                    Button("Clear") { viewModel.clear() }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .padding(.top, Theme.Spacing.md)
            }
            .padding(Theme.Spacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    /// `navigationDestination(item:)` needs a two-way binding, but `submitted`
    /// is read-only from outside — setting it to nil just pops back.
    private var submissionBinding: Binding<CountryFormViewModel.Submission?> {
        Binding(
            get: { viewModel.submitted },
            set: { if $0 == nil { viewModel.clear() } }
        )
    }
}
