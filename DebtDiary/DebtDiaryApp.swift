//
//  DebtDiaryApp.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import SwiftUI

@main
struct DebtDiaryApp: App {
    @StateObject var dataController = DataController()
    @StateObject var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            Group {
                ContentView()
                    .preferredColorScheme(.dark)
                    .tint(.white)
                    .font(.myMid)
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .environmentObject(appSettings)
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
