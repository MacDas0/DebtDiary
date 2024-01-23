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
    
    var body: some View {
        NavigationStack {
            TabView(selection: $lent) {
                MainView(lent: true)
                    .tabItem { Text("lent") }.tag(true)
                
                MainView(lent: false)
                    .tabItem { Text("borrowed") }.tag(false)
            }
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(lent ? "LENT" : "BORROWED").font(.myTitleBIG)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: { Image(systemName: "line.3.horizontal") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: { Image(systemName: "person.2") }
                }
            }
            .tabViewStyle(.page)
            .onAppear {
                dataController.deleteAll()
                dataController.createSampleData()
            }
        }
    }
}

#Preview {
    Tab()
}
