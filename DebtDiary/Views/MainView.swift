//
//  MainView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataController: DataController
    @Binding var filterPeople: Bool
    let lent: Bool

    var body: some View {
        Group {
            if !filterPeople {
                List(dataController.getTags()) { tag in
                    let cashForFilter = dataController.getCash(tag: tag, lent: lent)
                    if !cashForFilter.isEmpty {
                        Section {
                            ForEach(cashForFilter) { cash in
                                aListRow(cash: cash)
                            }
                        } header: {
                            HStack {
                                Spacer()
                                Text(tag.name.capitalized).font(.myMidMedium).foregroundStyle(.white)
                                Spacer()
                            }
                        }
                    }
                }.scrollContentBackground(.hidden)
            } else {
                List(dataController.getPeople()) { person in
                    let cashForFilter = dataController.getCash(person: person, lent: lent)
                    if !cashForFilter.isEmpty {
                        Section {
                            ForEach(cashForFilter) { cash in
                                aListRow(cash: cash)
                            }
                        } header: {
                            HStack {
                                Spacer()
                                Text(person.name.capitalized).font(.myMidMedium).foregroundStyle(.white)
                                Spacer()
                            }
                        }
                    }
                }.scrollContentBackground(.hidden) 
            }
        }.preferredColorScheme(.dark) .tint(.white) .listRowSpacing(2) .environment(\.defaultMinListRowHeight, 10)
    }
}
