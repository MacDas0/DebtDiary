//
//  aListRow.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct aListRow: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var appSettings: AppSettings
    let cash: Cash

    var body: some View {
        Button {
            
        } label: {
            HStack {
                Group {
//                    Image(systemName: "bell")
                    Text(cash.title).font(.myMid)
                    Spacer()
                    Text("\(String(cash.amount))").font(.myMidMedium)
                    Text(appSettings.currency).font(.myMidMedium)
                }.accessibilityElement() .accessibilityLabel("\(cash.title) \(cash.amount) \(appSettings.currency)")
            }
        }.listRowBackground(appSettings.gradient()) .frame(height: 10)
            .contextMenu {
                Button("Delete") { dataController.delete(cash) }
            }
    }
}
