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
    
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?
    
    @Published var amountLent = 0
    @Published var amountBorrowed = 0
    @Published var tags = [Tag]()
        
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file")
        }
        
        return managedObjectModel
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model", managedObjectModel: Self.model)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)

        container.loadPersistentStores { [weak self] _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(forStoreWith: description, coordinator: coordinator)
                    
                    self?.spotlightDelegate?.startSpotlightIndexing()
                }
            }
            
            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self?.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
        }
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    func createCash(amount: Int = 0, person: String = "", tag: String = "", lent: Bool = true, title: String = "", id: UUID = UUID(), reminderEnabled: Bool = false, reminderTime: Date = .now) {
        let cash = Cash(context: container.viewContext)
        cash.amount = amount
        cash.tag = FetchOrCreateTag(name: tag)
        cash.person = FetchOrCreatePerson(name: person)
        cash.title = title
        cash.id = id
        cash.lent = lent
        cash.cashDate = Date.now
        cash.cashReminderEnabled = reminderEnabled
        cash.reminderTime = reminderTime
        try? container.viewContext.save()
        updateAmounts()
    }
    
    func FetchAndCreateCash(amount: Int = 0, person: String = "", tag: String = "", lent: Bool = true, title: String = "", id: UUID = UUID(), reminderEnabled: Bool = false, reminderTime: Date = .now) -> Cash {
        let cash = Cash(context: container.viewContext)
        cash.amount = amount
        cash.tag = FetchOrCreateTag(name: tag)
        cash.person = FetchOrCreatePerson(name: person)
        cash.title = title
        cash.id = id
        cash.lent = lent
        cash.cashDate = Date.now
        cash.cashReminderEnabled = reminderEnabled
        cash.reminderTime = reminderTime
        try? container.viewContext.save()
        updateAmounts()
        return cash
    }
    
    func FetchOrCreateTag(name: String) -> Tag {
            let request = Tag.fetchRequest()
            let allTags = (try? container.viewContext.fetch(request)) ?? []
            if allTags.contains(where: { $0.name == name} ) {
                let thisTag = allTags.first(where: { $0.name == name })!
                tags.append(thisTag)
                return thisTag
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
    
    func updateAmounts() {
        amountLent = getAmount(lent: true)
        amountBorrowed = getAmount(lent: false)
    }
    
    func getAmount(lent: Bool) -> Int {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        return allCash.filter { $0.lent == lent }.map { $0.amount }.reduce(0, +)
    }
    
    func GetCash() -> [Cash] {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        return allCash.sorted()
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
                cash.cashAmount = 6
                person = FetchOrCreatePerson(name: "James")
                cash.cashTitle = "Bowling"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 2:
                cash.cashAmount = 10
                person = FetchOrCreatePerson(name: "Sarah")
                cash.cashTitle = "Cinema tickets"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 3:
                cash.cashAmount = 4
                person = FetchOrCreatePerson(name: "James")
                cash.cashTitle = "Train ticket"
                tag = FetchOrCreateTag(name: "Transport")
            case 4:
                cash.cashAmount = 32
                person = FetchOrCreatePerson(name: "Emma")
                cash.cashTitle = "Grocery shopping 15.01"
                tag = FetchOrCreateTag(name: "Groceries")
            case 5:
                cash.cashAmount = 100
                person = FetchOrCreatePerson(name: "James")
                cash.cashTitle = "Speeding ticket"
                tag = FetchOrCreateTag(name: "Emergency")
            default:
                cash.cashAmount = 25
                person = FetchOrCreatePerson(name: "Olivia")
                cash.cashTitle = "Dinner"
                tag = FetchOrCreateTag(name: "Food")
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
                cash.cashAmount = 15
                person = FetchOrCreatePerson(name: "Chris")
                cash.cashTitle = "Random jeans"
                tag = FetchOrCreateTag(name: "Fashion")
            case 2:
                cash.cashAmount = 50
                person = FetchOrCreatePerson(name: "Olivia")
                cash.cashTitle = "Secret ;)"
                tag = FetchOrCreateTag(name: "Other")
            case 3:
                cash.cashAmount = 11
                person = FetchOrCreatePerson(name: "Emily")
                cash.cashTitle = "Ice skating"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 4:
                cash.cashAmount = 15
                person = FetchOrCreatePerson(name: "Micheal")
                cash.cashTitle = "Pizza 29.12"
                tag = FetchOrCreateTag(name: "Food")
            default:
                cash.cashAmount = 12
                person = FetchOrCreatePerson(name: "Mom")
                cash.cashTitle = "Book"
                tag = FetchOrCreateTag(name: "Other")
            }
            cash.person = person
            cash.cashTag = tag
        }
        loadTags()
        try? viewContext.save()
        updateAmounts()
    }
    
    func loadTags() {
        if getTags().count == 0 {
            _ = FetchOrCreateTag(name: "Groceries")
            _ = FetchOrCreateTag(name: "Food")
            _ = FetchOrCreateTag(name: "Entertainment")
            _ = FetchOrCreateTag(name: "Transport")
            _ = FetchOrCreateTag(name: "Emergency")
            _ = FetchOrCreateTag(name: "Other")
            _ = FetchOrCreateTag(name: "")
        }
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
        
        let request3: NSFetchRequest<NSFetchRequestResult> = Person.fetchRequest()
        delete(request3)
        
        updateAmounts()
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func deleteOldTagsIfNotUsed() {
        for tag in tags {
            let oldTags = ["Subscription", "Rent", "Gift", "Fashion", "Medical"]
            if oldTags.contains(tag.name) {
                if tag.cash.isEmpty {
                    delete(tag)
                }
            }
            if tag.name == "---" {
                delete(tag)
            }
        }
    }
    
    func updateCashReminders() {
        for cash in GetCash() {
            if cash.reminderTime < Date.now {
                cash.cashReminderEnabled = false
            }
        }
    }
}
