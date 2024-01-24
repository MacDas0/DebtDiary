//
//  Tab.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct Tab: View {
    @EnvironmentObject var dataController: DataController
    @State private var lent = true
    @State private var filterPeople = true
    @State private var showSettings = false
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Main Tab
                TabView(selection: $lent) {
                    MainView(filterPeople: $filterPeople, lent: true)
                        .tabItem { Text("lent") }.tag(true)
                    
                    MainView(filterPeople: $filterPeople, lent: false)
                        .tabItem { Text("borrowed") }.tag(false)
                }
                // Bottom "ToolBar"
                VStack(spacing: 30) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Image("appIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 65)
                            .padding(.top)
                    }
                    // Page Indicators
                    HStack {
                        Rectangle().frame(width: 15, height: 3).opacity(lent ? 1 : 0.5)
                        Rectangle().frame(width: 15, height: 3).opacity(lent ? 0.5 : 1)
                    }
                }.offset(y: -20)
            }.background(Color.backgroundDark) .preferredColorScheme(.dark) .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(lent ? "LENT" : "BORROWED")
                        Text(String(lent ? dataController.amountLent : dataController.amountBorrowed))
                        Text("PLN")
                    }.font(.myTitleBIG)
                        .onTapGesture {
                            dataController.updateAmounts()
                        }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings.toggle()
                    } label: { Image(systemName: "line.3.horizontal") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        filterPeople.toggle()
                    } label: { Image(systemName: filterPeople ? "shippingbox" : "person.2") }
                }
            }
            .onAppear {
                dataController.deleteAll()
                dataController.createSampleData()
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showAdd) {
                AddSheet()
                    .presentationDetents([.height(500)])
            }
        }
    }
}

#Preview {
    Tab()
}
