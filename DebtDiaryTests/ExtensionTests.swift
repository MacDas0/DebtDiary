//
//  ExtensionTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 31/01/2024.
//

import CoreData
import XCTest
@testable import DebtDiary

final class ExtensionTests: BaseTestCase {
    func testCashUnwrapsWork() {
        let cash = Cash(context: moc)
        cash.cashTitle = "Example title"
        XCTAssertEqual(cash.title, "Example title", "Changing cashTitle should also change title")
        cash.title = "Updated title"
        XCTAssertEqual(cash.cashTitle, "Updated title", "Changing title should also change cashTitle")
        
        cash.cashAmount = 5
        XCTAssertEqual(cash.amount, 5, "Changing cashAmount should also change amount")
        cash.amount = 10
        XCTAssertEqual(cash.cashAmount, 10, "Changing amount should also change cashAmount")
        
        cash.cashLent = false
        XCTAssertEqual(cash.lent, false, "Changing cashLent should also change lent")
        cash.lent = true
        XCTAssertEqual(cash.cashLent, true, "Changing lent should also change cashLent")
        
        let testDate = Date.now
        cash.cashDate = testDate
        XCTAssertEqual(cash.date, testDate, "Changing cashDate should also change date")
        
        let id = UUID()
        cash.id = id
        XCTAssertEqual(cash.ID, id, "Changing id should also change ID")
        
        let tag = Tag(context: moc)
        let id1 = UUID()
        tag.name = "first tag"
        tag.id = id1
        cash.cashTag = tag
        XCTAssertEqual(cash.tag.name, "first tag", "Changing cashTag.name should chnage tag.name")
        XCTAssertEqual(cash.tag.ID, id1, "Changing tag.id should chnage tag.ID")
        cash.tag.name = "second tag"
        XCTAssertEqual(cash.cashTag!.name, "second tag", "Changing tag.name should change cashTag.name")
        
        let person = Person(context: moc)
        person.name = "first person"
        person.id = id1
        cash.cashPerson = person
        XCTAssertEqual(cash.person.name, "first person", "Changing cashPerson.name should chnage person.name")
        XCTAssertEqual(cash.person.ID, id1, "Changing person.id should chnage person.ID")
        cash.person.name = "second person"
        XCTAssertEqual(cash.cashPerson!.name, "second person", "Changing person.name should change cashPerson.name")
        
        XCTAssertEqual(tag.cash.count, 1, "There should be 1 tag.Cash for 1 cash with the tag")
        XCTAssertEqual(person.cash.count, 1, "There should be 1 person.Cash for 1 cash with the person")
        let extraCash = Cash(context: moc)
        extraCash.tag = tag
        extraCash.person = person
        XCTAssertEqual(tag.cash.count, 2, "There should be 2 tag.Cash for 2 cash with the tag")
        XCTAssertEqual(person.cash.count, 2, "There should be 2 person.Cash for 2 cash with the person")
    }
    
    func testSortingIsStable() {
        let date = Date.now
        let cash1 = Cash(context: moc)
        cash1.title = "B"
        cash1.cashDate = date
        let cash2 = Cash(context: moc)
        cash2.title = "B"
        cash2.cashDate = date.addingTimeInterval(1)
        let cash3 = Cash(context: moc)
        cash3.title = "A"
        cash3.cashDate = date.addingTimeInterval(10)
        
        let allCash = [cash1, cash2, cash3]
        let sorted = allCash.sorted()
        XCTAssertEqual(sorted, [cash1, cash2, cash3], "Sorting should always use name then creation date ")
        
        let person1 = dataController.FetchOrCreatePerson(name: "A")
        let person2 = dataController.FetchOrCreatePerson(name: "A")
        let person3 = dataController.FetchOrCreatePerson(name: "A")
        
        let peopleArray = [person1, person2, person3]
        let sortedPeople = peopleArray.sorted()
        let sortedPeople2 = peopleArray.sorted()
        let sortedPeople3 = peopleArray.sorted()
        let sortedPeople4 = peopleArray.sorted()
        XCTAssertEqual(sortedPeople, sortedPeople2, "If people are the same they should be stable sorted by id")
        XCTAssertEqual(sortedPeople3, sortedPeople4, "If people are the same they should be stable sorted by id")
        
        let tag1 = dataController.FetchOrCreateTag(name: "Fashion")
        let tag2 = dataController.FetchOrCreateTag(name: "Gift")
        let tag3 = dataController.FetchOrCreateTag(name: "Other")
        let tagArray = [tag1, tag2, tag3]
        let sortedTags = tagArray.sorted()
        XCTAssertEqual(sortedTags, [tag1, tag2, tag3], "tags should be sorted by custom order")
        tag1.name = "Other"
        tag2.name = "Other"
        let sortedTags2 = tagArray.sorted()
        let sortedTags3 = tagArray.sorted()
        let sortedTags4 = tagArray.sorted()
        let sortedTags5 = tagArray.sorted()
        XCTAssertEqual(sortedTags2, sortedTags3, "If tags are the same they should be stable sorted by id")
        XCTAssertEqual(sortedTags4, sortedTags5, "If tags are the same they should be stable sorted by id")
    }
    
    func testBundleDecoding() {
        let currencies = Bundle.main.decode([Currency].self, from: "Currency.json")
        XCTAssertFalse(currencies.isEmpty, "Currency.json should decode to a non-empty array")

        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, "Never ask a starfish for directions.", "The string must match DecodableString.json")
        
        let data2 = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data2.count, 3, "After loading data2 should have 3 items")
        XCTAssertEqual(data2["One"], 1, "The dictionary should contain the value 1 for the kay One.")
    }
}
