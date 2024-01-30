//
//  AssetTests.swift
//  DebtDiaryTests
//
//  Created by Maciej Daszkiewicz on 30/01/2024.
//

import XCTest
@testable import DebtDiary

final class AssetTests: XCTestCase {
    var appSettings = AppSettings()

    func testCurrencyLoadCorrectly() {
        XCTAssertTrue(AppSettings.allCurrencies.isEmpty == false, "Failed to load currencies from JSON")
    }
}
