//
//  CurrencyList.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 28/01/2024.
//

import SwiftUI

struct CurrencyList: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appSettings: AppSettings
    @State private var searchText = ""
    var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return AppSettings.allCurrencies
        } else {
            return AppSettings.allCurrencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
    @State private var showSearch = true

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        if appSettings.selectedCurrency != nil {
                            CurrencyRow(currencyName: appSettings.selectedCurrency!.name, currencyCode: appSettings.selectedCurrency!.code)
                                .listRowBackground(appSettings.gradient()) .scrollContentBackground(.hidden)
                        }
                    }
                    Section {
                        ForEach(filteredCurrencies) { currency in
                            CurrencyRow(currencyName: currency.name, currencyCode: currency.code)
                                .listRowBackground(appSettings.gradient()) .scrollContentBackground(.hidden)
                        }
                    }
                }.searchable(text: $searchText, isPresented: $showSearch, prompt: "Search") .scrollContentBackground(.hidden)
            }.background(Color.backgroundDark)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark") }
                }
            }
        }.onAppear(perform: appSettings.loadCurrencies)
    }
}

struct CurrencyRow: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    let currencyName: String
    let currencyCode: String

    var body: some View {
        Button {
            appSettings.currency = currencyCode
            dismiss()
        } label: {
            HStack {
                Text(currencyName)
                Spacer()
                Text(currencyCode)
            }
        }
    }
}

struct Currency: Codable, Identifiable {
    let name: String
    let code: String
    var id: String { code }
}
