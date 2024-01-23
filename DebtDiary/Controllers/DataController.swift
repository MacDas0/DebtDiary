//
//  DataController.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
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

        container.loadPersistentStores { storeDesription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func getCash(for tag: Tag, lent: Bool) -> [Cash] {
        let request = Cash.fetchRequest()
        let allCash = (try? container.viewContext.fetch(request)) ?? []
        let filteredCash = allCash.filter { $0.lent == lent && $0.tag == tag }
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
            return newTag
        }
    }
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        for i in 1...6 {
            let cash = Cash(context: viewContext)
            cash.id = UUID()
            cash.cashDate = Date.now
            cash.cashLent = true
            let tag: Tag
            switch i {
            case 1:
                cash.cashAmount = 65
                cash.cashPerson = "Tata"
                cash.cashTitle = "Roller do masażu mięśni"
                tag = FetchOrCreateTag(name: "Medical")
            case 2:
                cash.cashAmount = 85
                cash.cashPerson = "Tata"
                cash.cashTitle = "Płyn do mycia twarzy (anty-bakteryjny)"
                tag = FetchOrCreateTag(name: "Medical")
            case 3:
                cash.cashAmount = 160
                cash.cashPerson = "Tata"
                cash.cashTitle = "Apka do medytacji (roczne)"
                tag = FetchOrCreateTag(name: "Subscription")
            case 4:
                cash.cashAmount = 86
                cash.cashPerson = "Tata"
                cash.cashTitle = "HackingWithSwift"
                tag = FetchOrCreateTag(name: "Subscription")
            case 5:
                cash.cashAmount = 44
                cash.cashPerson = "Tata"
                cash.cashTitle = "Książka na kindla (Dune)"
                tag = FetchOrCreateTag(name: "Other")
            default:
                cash.cashAmount = 40
                cash.cashPerson = "Tata"
                cash.cashTitle = "Książka na kindla (Mastery)"
                tag = FetchOrCreateTag(name: "Other")
            }
            cash.cashTag = tag
        }
        for i in 1...5 {
            let cash = Cash(context: viewContext)
            cash.id = UUID()
            cash.cashDate = Date.now
            cash.cashLent = false
            let tag: Tag
            switch i {
            case 1:
                cash.cashAmount = 20
                cash.cashPerson = "Jasiek"
                cash.cashTitle = "Obiad w Aiole"
                tag = FetchOrCreateTag(name: "Food")
            case 2:
                cash.cashAmount = 80
                cash.cashPerson = "Tata"
                cash.cashTitle = "Zakupy w bierdonce"
                tag = FetchOrCreateTag(name: "Groceries")
            case 3:
                cash.cashAmount = 35
                cash.cashPerson = "Daria"
                cash.cashTitle = "Kino (kot w butach)"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 4:
                cash.cashAmount = 50
                cash.cashPerson = "Jasiek"
                cash.cashTitle = "Skin do lola"
                tag = FetchOrCreateTag(name: "Entertainment")
            case 5:
                cash.cashAmount = 2000
                cash.cashPerson = "Tata"
                cash.cashTitle = "Bitcoin"
                tag = FetchOrCreateTag(name: "Other")
            default:
                cash.cashAmount = 5
                cash.cashPerson = "Zgredzio"
                cash.cashTitle = "Bilet skm (do metropolii)"
                tag = FetchOrCreateTag(name: "Transport")
            }
            cash.cashTag = tag
        }
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
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
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Cash.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request2)
    }
}
