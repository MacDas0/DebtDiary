//
//  AppSettingsTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 30/01/2024.
//

import XCTest
@testable import DebtDiary

final class AppSettingsTests: XCTestCase {

    func testPinChangesAndSavingAndLoading() {
        let appSettings = AppSettings()
        appSettings.secretPin = "1111"
        appSettings.lockState = .lock
        
        let appSettings2 = AppSettings()
        appSettings2.loadSettings()
        XCTAssertEqual(appSettings2.secretPin, "1111", "PIN should == 1234 after loading")
        XCTAssertEqual(appSettings2.lockState, .lock, "lockState should be .lock after loading")
    }
}
