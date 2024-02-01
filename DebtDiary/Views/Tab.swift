//
//  Tab.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct Tab: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var appSettings: AppSettings
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
            }.background(Color.backgroundDark) .preferredColorScheme(.dark) .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Image("icon-\(appSettings.colorName)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding(.top)
                            .foregroundColor(appSettings.colorTheme)
                            .accessibilityLabel("Add")
                    }.padding(.bottom, 30) .sensoryFeedback(.selection, trigger: showAdd)
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        HStack {
                            Text(lent ? "LENT" : "BORROWED")
                            Text("\(String(lent ? dataController.amountLent : dataController.amountBorrowed))")
                            Text(appSettings.currency)
                        }.font(.myTitleBIG) .accessibilityElement() .accessibilityLabel("\(lent ? "LENT" : "BORROWED") \(String(lent ? dataController.amountLent : dataController.amountBorrowed)) \(appSettings.currency)")
                        // Page Indicators
                        HStack {
                            Rectangle().frame(width: 20, height: 3).opacity(lent ? 1 : 0.5)
                            Rectangle().frame(width: 20, height: 3).opacity(lent ? 0.5 : 1)
                        }
                    }.offset(y: 5)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings.toggle()
                    } label: { Image(systemName: "line.3.horizontal").font(.title3).accessibilityLabel("Settings") }
                        .sensoryFeedback(.selection, trigger: showSettings)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        filterPeople.toggle()
                    } label: { Image(systemName: filterPeople ? "person.2" : "shippingbox").font(.subheadline) .accessibilityLabel(filterPeople ? "Currently filtering by people" : "Currently filtering by category") .accessibilityHint(filterPeople ? "Click to filter by category" : "Click to filter by people") } .sensoryFeedback(.selection, trigger: filterPeople)
                }
            }
            .onAppear {
                dataController.loadTags()
                dataController.deleteOldTagsIfNotUsed()
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
