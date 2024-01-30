//
//  DebtDiaryTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import CoreData
import XCTest
@testable import DebtDiary

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var moc: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        moc = dataController.container.viewContext
    }
}
