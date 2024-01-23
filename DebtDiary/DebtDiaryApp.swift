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
    
    var body: some Scene {
        WindowGroup {
            Group {
                Tab()
                    .preferredColorScheme(.dark)
                    .tint(.white)
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
