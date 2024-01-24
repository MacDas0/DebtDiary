//
//  PreferencesView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List {
                Group {
                    // Currency, Language, Haptics
                    Section {
                        Picker("Currency", selection: $appSettings.currency) {
                            ForEach(appSettings.supportedCurrencies, id: \.self) { currency in
                                Text(currency)
                            }
                        }
                        Picker("App Language", selection: $appSettings.language) {
                            ForEach(appSettings.supportedLanguages, id: \.self) { language in
                                Text(language)
                            }
                        }
                        Toggle("Use Haptic Feedback", isOn: $appSettings.UseHaptics).tint(appSettings.colorTheme)
                    } header: {
                        SectionHeader(text: "")
                    }
                }.listRowBackground(appSettings.gradient())
            }.background(Color.backgroundDark) .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("PREFERENCES").font(.myTitleBIG)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark") }
                }
            }
        }
    }
}

#Preview {
    PreferencesView()
}

struct SectionHeader: View {
let text: String
    var body: some View {
        HStack {
            Spacer()
            Text(text.capitalized).font(.myMidMedium).foregroundStyle(.white)
            Spacer()
        }
    }
}
