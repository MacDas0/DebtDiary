//
//  DebtDiaryUITests.swift
//  DebtDiaryUITests
//
//  Created by Maciej Daszkiewicz on 22/01/2024.
//

import XCTest

final class DebtDiaryUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppStartsWithNavBar() throws {
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a nav bar when the app launches")
    }
    
    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Settings"].exists, "There should be a settings button on launch")
        XCTAssertTrue(app.navigationBars.buttons["Currently filtering by people"].exists, "There should be a filter button on launch")
        XCTAssertTrue(app.buttons["Add"].exists, "There should be a add button on launch")
    }
    
    func testNoIssuesAtStart() throws {
        XCTAssertEqual(app.cells.count, 1, "There should be 0 list rows initially.")
    }
    
    func testCreatingAndDeletingCash() {
        for tapCount in 1...5 {
            app.buttons["Add"].tap()
            app.buttons["Create"].tap()
            XCTAssertEqual(app.cells.count, tapCount+2 ,"There should be \(tapCount+1) rows in the list.")
        }
        for taps in (0...4).reversed() {
            app.cells.element(boundBy: 2).press(forDuration: 0.7)
            app.buttons["Delete"].tap()
            XCTAssertEqual(app.cells.count, taps != 0 ? taps+2 : taps+1, "There should be \(taps) rows in the list")
        }
    }
    
    func testCreatingCustomCash() {
        app.buttons["Add"].tap()
        app.buttons["tag as borrowed"].tap()
        app.textFields["Amount"].tap()
        app.typeText("100")
        app.textFields["Person"].tap()
        app.typeText("Tata")
        app.textFields["Title"].tap()
        app.typeText("Nic ciekawego")
        app.buttons["Food"].tap()
        app.buttons["Create"].tap()
        app.swipeLeft()
        XCTAssertTrue(app.staticTexts["Nic ciekawego"].exists, "Nic ciekawego should be the title")
        XCTAssertTrue(app.staticTexts["100"].exists, "100 should be the amount")
        XCTAssertTrue(app.staticTexts["Tata"].exists, "Tata should be the person")
        app.buttons["Currently filtering by people"].tap()
        XCTAssertTrue(app.staticTexts["Food"].exists, "Food should be the category")
    }
    
    func testChangingCurrency() {
        app.buttons["Settings"].tap()
        app.buttons["Currency"].tap()
        app.typeText("PLN")
        app.cells.element(boundBy: 1).tap()
        app.buttons["Exit"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["PLN"].exists, "After changing currency it should be PLN")
    }
    
    func testDeleteAllData() {
        for tapCount in 1...5 {
            app.buttons["Add"].tap()
            app.buttons["Create"].tap()
            XCTAssertEqual(app.cells.count, tapCount+2 ,"There should be \(tapCount+1) rows in the list.")
        }
        app.buttons["Settings"].tap()
        app.buttons["Delete All Data"].tap()
        app.buttons["DELETE ALL DATA"].tap()
        XCTAssertEqual(app.cells.count, 1, "After deleting data there should be just 1 cell (not data)")
    }
    
    func testContactUsShowsEverything() {
        app.buttons["Settings"].tap()
        app.buttons["Contact Us"].tap()
        XCTAssertTrue(app.segmentedControls["Type Picker"].exists, "")
    }
    
    func testPinCreation() {
        app.buttons["Settings"].tap()
        app.buttons["PIN Lock"].tap()
        app.buttons["Create PIN Lock"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["Settings"].tap()
        app.buttons["PIN Lock"].tap()
        app.buttons["Change PIN code"].tap()
        app.buttons["001"].tap()
        app.buttons["001"].tap()
        app.buttons["001"].tap()
        app.buttons["001"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["2"].tap()
        app.buttons["Settings"].tap()
        app.buttons["PIN Lock"].tap()
        app.buttons["Remove PIN Lock"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["1"].tap()
        app.buttons["Settings"].tap()
        app.buttons["PIN Lock"].tap()
        XCTAssertTrue(app.buttons["Create PIN Lock"].exists, "")
    }
}
