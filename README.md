# iOS Take-Home Starter

A small SwiftUI starter for timed take-home assessments (2 hours to a day).
No third-party dependencies.

Deliberately small. A take-home is judged on whether you solved *that* problem
well — handing in thousands of lines of unused infrastructure reads as poor
scope judgement, however good the code is.

## Starting an assessment

```bash
git clone <this repo> TakeHomeAcme
cd TakeHomeAcme
rm -rf .git && git init          # fresh history, starts at the assessment
Scripts/rename.sh TakeHomeAcme com.yourname
```

Then:

1. Point `APIConfig.baseURL` at whatever API the brief gives you.
2. Delete `TakeHomeStarter/Features/Example/` and the matching test file.
3. Build your screen.

## Disclose the reuse

Put this in the submission's README. Disclosed reuse reads as confidence;
discovered reuse raises questions:

> Scaffolding (networking, form components, loading/error states) adapted from
> my own iOS starter: `<link>`

Many companies allow reusing your own prior code. When the brief doesn't say,
saying so yourself is the safe play.

## What's in it

| | |
|---|---|
| `Core/Networking` | `APIClient` protocol + `LiveAPIClient` (plain `URLSession`), `APIError` with one `classify` funnel |
| `Core/UI` | `LoadState` + `LoadableViewModel.perform` (idle → loading → loaded/empty/failed), `ActionState` for one-shot buttons, `ErrorStateView`, `SkeletonView` |
| `Components` | `PickerField` + `SelectionSheet`, `AppTextField`, `EmailField`, `SearchField`, `FieldContainer` |
| `DesignSystem` | `Theme` — spacing, colours, fonts |
| `Features/Example` | A worked reference. Delete it. |

## PickerField

The piece worth knowing about. A form field that opens a searchable sheet,
rather than an inline dropdown — so it stays usable with hundreds or thousands
of items. Works with any `Hashable` type:

```swift
// Plain strings
PickerField(label: "Region", items: regions,
            selection: $region, title: { $0 })

// A struct, with a second line, disabled until another field is set
PickerField(label: "Country", items: countriesInRegion,
            selection: $country, title: \.name, subtitle: \.capital,
            error: countryError,
            isEnabled: region != nil)
```

`SelectionSheet` is usable on its own if you just need "pick one from a list".

**If a brief explicitly asks for an inline autocomplete capped at N results,**
build that instead — reviewers with a checklist mark missing requirements even
when the alternative is better. Then note the trade-off in your README; you get
the requirement *and* the judgement.

## The worked example

The classic form assessment: text field with validation, two dependent pickers
fed by an API, submit to a result screen.

It uses `https://api.first.org/data/v1/countries?limit=300` — free, no API key,
returns country + region in one call.

**Note:** the `restcountries.com/v3.1` endpoint that older versions of this
assessment specify is now deprecated, and v5 requires an API key. If a brief
hands you that URL, say so — it's worth a sentence to the interviewer.

## Tests

`TakeHomeStarterTests` covers the example's validation and derived lists.
Run with ⌘U. Tests only run on the **Development** scheme —
`ENABLE_TESTABILITY` is off in the other configurations.
