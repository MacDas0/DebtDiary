//
//  MainView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataController: DataController
    let lent: Bool
    @State private var showPeople = true
    @EnvironmentObject var dataControlelr: DataController
    @FetchRequest(sortDescriptors: [SortDescriptor(\.tagName)]) var tags: FetchedResults<Tag>
    
    var filters: [Filter] {
        let allTags = tags.map { tag in
            Filter(name: tag.name, tag: tag)
        }
        let uniqueTags = Set(allTags)
        return Array(uniqueTags)
    }
    
    var body: some View {
        List(filters) { filter in
            let cashForFilter = dataControlelr.getCash(for: filter.tag, lent: lent)
            if !cashForFilter.isEmpty {
                Section(filter.name.capitalized) {
                    ForEach(cashForFilter) { cash in
                        Text(cash.title)
                    }
                }
            }
        }.preferredColorScheme(.dark) .tint(.white)
    }
}

#Preview {
    MainView(lent: true)
}
