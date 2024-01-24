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
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.backgroundDark).ignoresSafeArea()
                    // Delete All Data
                    Button {
                        dismiss()
                        deletedAllData = true
                        dataController.deleteAll()
                    } label: {
                        Text("DELETE ALL DATA").font(.myMidMedium).padding()
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(appSettings.gradient(color: Color.customRed)))
                    }
                }
            }
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


