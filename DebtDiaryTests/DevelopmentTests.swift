//
//  DevelopmentTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 30/01/2024.
//

import CoreData
import XCTest
@testable import DebtDiary

final class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() {
        dataController.createSampleData()
        
        XCTAssertEqual(dataController.count(for: Cash.fetchRequest()), 11, "There should be 11 cash")
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 12, "There should be 12 tags (loadTags())")
        XCTAssertEqual(dataController.count(for: Person.fetchRequest()), 8, "There should be 8 people")
    }
    
    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Cash.fetchRequest()), 0, "There should be 0 cash after deletion")
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "There should be 0 tags after deletion")
        XCTAssertEqual(dataController.count(for: Person.fetchRequest()), 0, "There should be 0 people after deletion")
    }
}
