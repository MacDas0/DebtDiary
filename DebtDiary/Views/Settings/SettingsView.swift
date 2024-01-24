//
//  SettingsView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var colorManager: AppSettings
    @Environment(\.dismiss) var dismiss

    @State private var preferences = false
    @State private var appearance = false
    @State private var pinLock = false
    @State private var history = false
    @State private var contactUs = false
    @State private var reportABug = false
    @State private var deleteAllData = false
    @State private var termsAndConditions = false
    @State private var privacyPolicy = false
    @State private var deletedAllData = false

    var body: some View {
        NavigationStack {
            List {
                Group {
                    Section {
                        Button("Preferences") { preferences.toggle() }
                        Button("Appearance") { appearance.toggle() }
                    }
                    Section {
                        Button("Pin lock") { }
                        Button("History") { }
                    }
                    Section {
                        Button("Contact us") { }
                        Button("Report a bug") { }
                    }
                    Section {
                        Button("Delete all data") { deleteAllData.toggle() }
                    }
                    Section {
                        Button("Terms and conditions") { }
                        Button("Privacy policy") { }
                    }
                }.listRowBackground(colorManager.gradient())
            }.background(Color.backgroundDark) .scrollContentBackground(.hidden)
            .sheet(isPresented: $preferences) { PreferencesView().presentationDetents([.medium])}
            .fullScreenCover(isPresented: $appearance) { AppearanceView()}
            .sheet(isPresented: $deleteAllData) { DeleteAllDataView(deletedAllData: $deletedAllData).presentationDetents([.medium]) .onDisappear { if deletedAllData == true { dismiss() } }}
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SETTINGS").font(.myTitleBIG)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
