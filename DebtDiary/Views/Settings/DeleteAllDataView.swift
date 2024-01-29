//
//  DeleteAllDataView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI

struct DeleteAllDataView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @Binding var deletedAllData: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ZStack {
                    Button {
                        dismiss()
                        deletedAllData = true
                        dataController.deleteAll()
                    } label: {
                        Text("DELETE ALL DATA").font(.myMidMedium).padding()
                    }
                }.listRowBackground(appSettings.gradient(color: Color.customRed))
            }.scrollContentBackground(.hidden) .background(Color.backgroundDark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark") }
                }
            }
        }
    }
}


