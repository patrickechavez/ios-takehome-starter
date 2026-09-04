//
//  PickerField.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct PickerField<Item: Hashable>: View {

    let label: String
    var placeholder: String = "Select"

    let items: [Item]
    @Binding var selection: Item?

    let title: (Item) -> String

    var subtitle: ((Item) -> String)?

    var error: String?
    var isEnabled: Bool = true

    @State private var isPresented = false

    var body: some View {
        FieldContainer(label: label, error: error) {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Text(selection.map(title) ?? placeholder)
                        .foregroundStyle(
                            selection == nil ? Theme.Color.tertiaryText : Theme.Color.primaryText
                        )

                    Spacer()

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.footnote)
                        .foregroundStyle(Theme.Color.secondaryText)
                }
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.5)
        }
        .sheet(isPresented: $isPresented) {
            SelectionSheet(
                title: label,
                items: items,
                selection: $selection,
                rowTitle: title,
                rowSubtitle: subtitle
            )
        }
    }
}

struct SelectionSheet<Item: Hashable>: View {

    let title: String
    let items: [Item]
    @Binding var selection: Item?

    let rowTitle: (Item) -> String
    var rowSubtitle: ((Item) -> String)?

    @State private var query = ""
    @Environment(\.dismiss) private var dismiss

    private var matches: [Item] {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !term.isEmpty else { return items }
        return items.filter { rowTitle($0).localizedCaseInsensitiveContains(term) }
    }

    var body: some View {
        NavigationStack {
            List(matches, id: \.self) { item in
                Button {
                    selection = item
                    dismiss()
                } label: {
                    row(for: item)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .overlay {
                if matches.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .searchable(text: $query, prompt: "Search")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func row(for item: Item) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Theme.Spacing.xs / 2) {
                Text(rowTitle(item))
                    .foregroundStyle(Theme.Color.primaryText)

                if let rowSubtitle {
                    Text(rowSubtitle(item))
                        .font(Theme.Font.secondary)
                        .foregroundStyle(Theme.Color.secondaryText)
                }
            }

            Spacer()

            if item == selection {
                Image(systemName: "checkmark")
                    .foregroundStyle(Theme.Color.accent)
            }
        }
        .contentShape(Rectangle())
    }
}
