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
    @State private var currencies: [Currency] = []
    var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
            }
        }
    }
    @State private var showSearch = true
    @State private var selectedCurrency: Currency?

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        if selectedCurrency != nil {
                            CurrencyRow(currencyName: selectedCurrency!.name, currencyCode: selectedCurrency!.code)
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
        }.onAppear(perform: loadCurrencies)
    }
    
    func loadCurrencies() {
        guard let url = Bundle.main.url(forResource: "Currency", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate Currencies.json in bundle.")
        }

        do {
            let decoder = JSONDecoder()
            self.currencies = try decoder.decode([Currency].self, from: data)
        } catch {
            fatalError("Error decoding currencies: \(error.localizedDescription)")
        }
        self.selectedCurrency = currencies.first(where: { $0.code == appSettings.currency })
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
