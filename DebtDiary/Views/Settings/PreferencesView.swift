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
                        NavigationLink {
                            CurrencyList()
                        } label: {
                            HStack {
                                Text("Currency")
                                Spacer()
                                Text(appSettings.currency).opacity(0.6)
                            }
                        }
//                        Picker("App Language", selection: $appSettings.language) {
//                            ForEach(appSettings.supportedLanguages, id: \.self) { language in
//                                Text(language)
//                            }
//                        }.pickerStyle(NavigationLinkPickerStyle())
//                        Toggle("Use Haptic Feedback", isOn: $appSettings.UseHaptics).tint(appSettings.colorTheme)
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
            Text(LocalizedStringKey(text.capitalized)).font(.myMidMedium).foregroundStyle(.white)
            Spacer()
        }
    }
}

