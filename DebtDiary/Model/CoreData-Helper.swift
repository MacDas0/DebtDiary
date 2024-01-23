//
//  CoreData-Helper.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import Foundation

extension Cash: Comparable {
    var amount: Int {
        get { Int(cashAmount) }
        set { cashAmount = Int16(newValue) }
    }
    
    var title: String {
        get { cashTitle ?? "" }
        set { cashTitle = newValue }
    }
    
    var person: String {
        get { cashPerson ?? "" }
        set { cashPerson = newValue }
    }
    
    var lent: Bool {
        get { cashLent }
        set { cashLent = newValue }
    }
    
    var date: Date {
        cashDate ?? .now
    }
    
    var ID: UUID {
        id ?? UUID()
    }
    
    var tag: Tag {
        get { cashTag ?? Tag() }
        set { cashTag = newValue}
    }
    
    public static func <(lhs: Cash, rhs: Cash) -> Bool {
        let left = lhs.date
        let right = rhs.date
        let left2 = lhs.title.localizedLowercase
        let right2 = rhs.title.localizedLowercase
        
        if left == right && left2 == right2 {
            return lhs.ID.uuidString < rhs.ID.uuidString
        } else if right == left {
            return left2 < right2
        } else {
            return left > right
        }
    }
}

extension Tag: Comparable {
    var name: String {
        get { tagName ?? "" }
        set { tagName = newValue }
    }
    
    var ID: UUID {
        id ?? UUID()
    }
    
    var cash: [Cash] {
        let result = tagCash?.allObjects as? [Cash] ?? []
        return result.sorted()
    }
    
    public static func <(lhs: Tag, rhs: Tag) -> Bool {
        let left = lhs.name
        let right = rhs.name
        
        if left == right {
            return lhs.ID.uuidString < rhs.ID.uuidString
        } else {
            return left < right
        }
    }
}
