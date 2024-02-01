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
    @State private var appLock = false
    @State private var history = false
    @State private var contactUs = false
    @State private var deleteAllData = false
    @State private var termsAndConditions = false
    @State private var privacyPolicy = false
    @State private var deletedAllData = false

    var body: some View {
        NavigationStack {
            List {
                Group {
                    Section {
                        Button("Appearance") { appearance.toggle() }
                    }
                    Section {
                        Button("Contact Us") { contactUs.toggle()}
                    }
                    Section {
                        Button("PIN Lock") { appLock.toggle() }
//                        Button("History") { }
                    }
                    Section {
                        Button("Currency") { preferences.toggle() }
                    }
                    Section {
                        Button("Delete All Data") { deleteAllData.toggle() }
                    }
                    Section {
                        Link("Privacy Policy", destination: URL(string: "https://www.termsfeed.com/live/d3cea12a-d879-426e-bc2c-02420d634fa4")!)
                    }
                    Section {
                        Link("Terms and Conditions", destination: URL(string: "https://www.termsfeed.com/live/d3bee33f-a748-4a1c-9d04-adb198db0b3c")!)

                    }
                }.listRowBackground(colorManager.gradient())
            }.background(Color.backgroundDark) .scrollContentBackground(.hidden)
            .sheet(isPresented: $preferences) { CurrencyList().presentationDetents([.medium])}
            .sheet(isPresented: $appearance) { AppearanceView().presentationDetents([.medium])}
            .sheet(isPresented: $contactUs) { ContactUsView().presentationDetents([.medium])}
            .sheet(isPresented: $appLock) { AppLockView().presentationDetents([.medium])}
            .sheet(isPresented: $deleteAllData) { DeleteAllDataView(deletedAllData: $deletedAllData).presentationDetents([.medium]) .onDisappear { if deletedAllData == true { dismiss() } }}
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SETTINGS").font(.myTitleBIG)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark").accessibilityIdentifier("Exit")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
