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
        HStack {
            Text(cash.title).font(.myMid)
            Spacer()
            Text(String(cash.amount)).font(.myMidMedium)
            Text("PLN").font(.myMidMedium)
        }.listRowBackground(appSettings.gradient())
        .contextMenu {
            Button("Delete") {
                dataController.delete(cash)
            }
        }
    }
}
