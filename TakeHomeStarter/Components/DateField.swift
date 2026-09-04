//
//  DateField.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

struct DateField: View {

    let label: String

    @Binding var date: Date?

    var placeholder: String = "Select"
    var error: String?
    var isRequired: Bool = false
    var isEnabled: Bool = true

    var range: ClosedRange<Date>?

    private let format: String
    private let formatter: DateFormatter

    @State private var isPresented = false

    init(
        label: String,
        date: Binding<Date?>,
        format: String = "MM/dd/yyyy",
        placeholder: String = "Select",
        error: String? = nil,
        isRequired: Bool = false,
        isEnabled: Bool = true,
        range: ClosedRange<Date>? = nil
    ) {
        self.label = label
        _date = date
        self.format = format
        self.placeholder = placeholder
        self.error = error
        self.isRequired = isRequired
        self.isEnabled = isEnabled
        self.range = range

        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        self.formatter = formatter
    }

    var body: some View {
        FieldContainer(label: label, isRequired: isRequired, error: error) {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Text(date.map(formatter.string(from:)) ?? placeholder)
                        .foregroundStyle(
                            date == nil ? Theme.Color.tertiaryText : Theme.Color.primaryText
                        )

                    Spacer()

                    Image(systemName: "calendar")
                        .font(.footnote)
                        .foregroundStyle(Theme.Color.secondaryText)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.5)
        }
        .sheet(isPresented: $isPresented) {
            DateSheet(title: label, date: $date, range: range)
        }
    }
}

struct DateSheet: View {

    let title: String
    @Binding var date: Date?
    var range: ClosedRange<Date>?

    @State private var selection: Date
    @Environment(\.dismiss) private var dismiss

    init(title: String, date: Binding<Date?>, range: ClosedRange<Date>? = nil) {
        self.title = title
        _date = date
        self.range = range
        _selection = State(wrappedValue: date.wrappedValue ?? Date())
    }

    var body: some View {
        NavigationStack {
            VStack {
                picker
                    .datePickerStyle(.graphical)
                    .labelsHidden()

                Spacer()
            }
            .padding(Theme.Spacing.lg)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        date = selection
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
    }

    @ViewBuilder
    private var picker: some View {
        if let range {
            DatePicker("", selection: $selection, in: range, displayedComponents: .date)
        } else {
            DatePicker("", selection: $selection, displayedComponents: .date)
        }
    }
}
