//
//  DataControllerTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 30/01/2024.
//

import CoreData
import XCTest
@testable import DebtDiary

final class DataControllerTests: BaseTestCase {
    let count = 5
    
    func testCreateCashAndTagsAndPeople() throws {
        for nr in 0..<count {
            dataController.createCash(amount: 1, person: String(nr), tag: String(nr))
        }

        XCTAssertEqual(dataController.count(for: Cash.fetchRequest()), count, "Expected 5 cash")
        XCTAssertEqual(dataController.getTags().count, count, "Expected 5 tags")
        XCTAssertEqual(dataController.getPeople().count, count, "Expected 5 people")
        XCTAssertEqual(dataController.getAmount(lent: true), count, "Expected amount lent == 5")
        XCTAssertEqual(dataController.getAmount(lent: false), 0, "Expected amount borrowed == 0")
        let tag = dataController.getTags().sorted().first
        let person = dataController.getPeople().first
        XCTAssertEqual(dataController.getCash(tag: tag!, lent: true).count, 1, "Cash for any tag should equal 1")
        XCTAssertEqual(dataController.getCash(person: person!, lent: true).count, 1, "Cash for any person should equal 1")
    }
}
