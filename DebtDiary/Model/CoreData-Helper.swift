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
    
    var person: Person {
        get { cashPerson ?? Person() }
        set { cashPerson = newValue }
    }
    
    var reminderTime: Date {
        get { cashReminderTime ?? .now }
        set { cashReminderTime = newValue }
    }
    
    var reminderEnabled: Bool {
        cashReminderEnabled
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
            return left < right
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
        let order = ["Food", "Groceries", "Transport", "Entertainment", "Fashion", "Rent", "Subscription", "Medical", "Emergency", "Gift", "Refund", "Other"]
        
        let leftPriority = order.firstIndex(of: lhs.name) ?? order.count
        let rightPriority = order.firstIndex(of: rhs.name) ?? order.count

        if leftPriority != rightPriority {
            return leftPriority < rightPriority
        } else {
            return lhs.ID.uuidString < rhs.ID.uuidString
        }
    }
}

extension Person: Comparable {
    var name: String {
        get { personName ?? "" }
        set { personName = newValue }
    }
    
    var ID: UUID {
        id ?? UUID()
    }
    
    var cash: [Cash] {
        let result = personCash?.allObjects as? [Cash] ?? []
        return result.sorted()
    }
    
    public static func <(lhs: Person, rhs: Person) -> Bool {
        let left = lhs.name
        let right = rhs.name
        
        if left == right {
            return lhs.ID.uuidString < rhs.ID.uuidString
        } else {
            return left < right
        }
    }
}
