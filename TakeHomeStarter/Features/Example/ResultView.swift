//
//  ResultView.swift
//  TakeHomeStarter
//

import SwiftUI

struct ResultView: View {

    let submission: CountryFormViewModel.Submission

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Text("Hi \(submission.name)")
                .font(Theme.Font.sectionTitle)

            Text("You are from \(submission.region), \(submission.country)")
                .font(Theme.Font.body)
                .foregroundStyle(Theme.Color.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(Theme.Spacing.xxl)
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}
