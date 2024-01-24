//
//  DataController.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    @Published var amountLent = 0
    @Published var amountBorrowed = 0
    @Published var tags = [Tag]()
        
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)

        container.loadPersistentStores { storeDesription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
//    func editCash(cash: Cash, amount: Int = 0, person: String = "", tag: String = "", lent: Bool = true, title: String = "", id: UUID = UUID()) {
//        cash.amount = amount
//        cash.tag = FetchOrCreateTag(name: tag)
//        cash.person = FetchOrCreatePerson(name: person)
//        cash.title = title
//        cash.id = id
//        cash.lent = lent
//        cash.cashDate = Date.now
//        try? container.viewContext.save()
//    }
    
    func createCash(amount: Int = 0, person: String = "", tag: String = "", lent: Bool = true, title: String = "", id: UUID = UUID()) {
        let cash = Cash(context: container.viewContext)
        cash.amount = amount
        cash.tag = FetchOrCreateTag(name: tag)
        cash.person = FetchOrCreatePerson(name: person)
        cash.title = title
        cash.id = id
        cash.lent = lent
        cash.cashDate = Date.now
        try? container.viewContext.save()
        updateAmounts()
    }
    
    func updateAmounts() {
        amountLent = getAmount(lent: true)
        amountBorrowed = getAmount(lent: false)
    }
    
    func getAmount(lent: Bool) -> Int {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        return allCash.filter { $0.lent == lent }.map { $0.amount }.reduce(0, +)
    }
    
    func getPeople() -> [Person] {
        let request = Person.fetchRequest()
        let allPeople = (try? container.viewContext.fetch(request)) ?? []
        let uniquePeople = Set(allPeople)
        return Array(uniquePeople).sorted()
    }
    
    func getTags() -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []
        let uniqueTags = Set(allTags)
        return Array(uniqueTags).sorted()
    }
    
    func getCash(tag: Tag, lent: Bool) -> [Cash] {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        let filteredCash = allCash.filter { $0.lent == lent && $0.tag == tag }
        return filteredCash.sorted()
    }
    
    func getCash(person: Person, lent: Bool) -> [Cash] {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        let filteredCash = allCash.filter { $0.lent == lent && $0.person == person }
        return filteredCash.sorted()
    }
    
    func FetchOrCreateTag(name: String) -> Tag {
            let request = Tag.fetchRequest()
            let allTags = (try? container.viewContext.fetch(request)) ?? []
            if allTags.contains(where: { $0.name == name} ) {
                return allTags.first(where: { $0.name == name })!
            } else {
                let newTag = Tag(context: container.viewContext)
                newTag.id = UUID()
                newTag.name = name
                tags.append(newTag)
                return newTag
            }
        }
        
    func FetchOrCreatePerson(name: String) -> Person {
        let request = Person.fetchRequest()
        let allPeople = (try? container.viewContext.fetch(request)) ?? []
        if allPeople.contains(where: { $0.name == name} ) {
            return allPeople.first(where: { $0.name == name })!
        } else {
            let newPerson = Person(context: container.viewContext)
            newPerson.id = UUID()
            newPerson.name = name
            return newPerson
        }
    }

    
    func createSampleData() {
        let viewContext = container.viewContext
        
        for i in 1...6 {
            let cash = Cash(context: viewContext)
            cash.id = UUID()
            cash.cashDate = Date.now
            cash.cashLent = true
            let person: Person
            let tag: Tag
            switch i {
            case 1:
                cash.cashAmount = 65
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Roller do masażu mięśni"
                tag = FetchOrCreateTag(name: "Medical")
            case 2:
                cash.cashAmount = 85
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Płyn do mycia twarzy (anty-bakteryjny)"
                tag = FetchOrCreateTag(name: "Medical")
            case 3:
                cash.cashAmount = 160
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Apka do medytacji (roczne)"
                tag = FetchOrCreateTag(name: "Subscription")
            case 4:
                cash.cashAmount = 86
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "HackingWithSwift"
                tag = FetchOrCreateTag(name: "Subscription")
            case 5:
                cash.cashAmount = 44
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Książka na kindla (Dune)"
                tag = FetchOrCreateTag(name: "Other")
            default:
                cash.cashAmount = 40
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Książka na kindla (Mastery)"
                tag = FetchOrCreateTag(name: "Other")
            }
            cash.cashPerson = person
            cash.cashTag = tag
        }
        for i in 1...5 {
            let cash = Cash(context: viewContext)
            cash.id = UUID()
            cash.cashDate = Date.now
            cash.cashLent = false
            let person: Person
            let tag: Tag
            switch i {
            case 1:
                cash.cashAmount = 20
                person = FetchOrCreatePerson(name: "Jasiek")
                cash.cashTitle = "Obiad w Aiole"
                tag = FetchOrCreateTag(name: "Food")
            case 2:
                cash.cashAmount = 80
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Zakupy w bierdonce"
                tag = FetchOrCreateTag(name: "Groceries")
            case 3:
                cash.cashAmount = 35
                person = FetchOrCreatePerson(name: "Daria")
                cash.cashTitle = "Kino (kot w butach)"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 4:
                cash.cashAmount = 50
                person = FetchOrCreatePerson(name: "Jasiek")
                cash.cashTitle = "Skin do lola"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 5:
                cash.cashAmount = 2000
                person = FetchOrCreatePerson(name: "Tata")
                cash.cashTitle = "Bitcoin"
                tag = FetchOrCreateTag(name: "Other")
            default:
                cash.cashAmount = 5
                person = FetchOrCreatePerson(name: "Zgredzio")
                cash.cashTitle = "Bilet skm (do metropolii)"
                tag = FetchOrCreateTag(name: "Transport")
            }
            cash.person = person
            cash.cashTag = tag
        }
        _ = FetchOrCreateTag(name: "Transport")
        _ = FetchOrCreateTag(name: "Rent")
        _ = FetchOrCreateTag(name: "Utility")
        _ = FetchOrCreateTag(name: "Gift")
        _ = FetchOrCreateTag(name: "Fashion")
        _ = FetchOrCreateTag(name: "Emergency")
        _ = FetchOrCreateTag(name: "Refund")
        try? viewContext.save()
        updateAmounts()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
        updateAmounts()
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
                           NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
        updateAmounts()
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Cash.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request2)
        updateAmounts()
    }
}
