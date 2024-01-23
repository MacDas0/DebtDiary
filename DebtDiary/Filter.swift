//
//  Filter.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import Foundation

struct Filter: Identifiable, Hashable, Equatable {
    var id = UUID()
    var name: String
    var tag: Tag
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
