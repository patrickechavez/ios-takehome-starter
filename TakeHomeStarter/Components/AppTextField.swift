//
//  AppTextField.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI
import UIKit

struct AppTextField: View {

    @Binding var text: String

    var placeholder: String = ""
    var label: String?
    var error: String?
    var isRequired: Bool = false

    var keyboard: UIKeyboardType = .default
    var capitalization: TextInputAutocapitalization = .sentences
    var contentType: UITextContentType?
    var disableAutocorrection: Bool = false
    var submitLabel: SubmitLabel = .return

    var body: some View {
        FieldContainer(label: label, isRequired: isRequired, error: error) {
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(capitalization)
                .textContentType(contentType)
                .autocorrectionDisabled(disableAutocorrection)
                .submitLabel(submitLabel)
                .accessibilityLabel(label.map(Text.init) ?? Text(placeholder))
        }
    }
}

struct InlineErrorText: View {

    private let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(Theme.Font.secondary)
            .foregroundStyle(Theme.Color.danger)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isStaticText)
    }
}
