//
//  StringFilterTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

class StringFilterTest: XCTestCase {
    func testFilterMatches() {
        let filter = StringFilter(property: .expansion, value: "Test", operation: .equal)
        XCTAssert(filter.match(TestData.actionCard))
    }
    func testFilterDoesntMatch() {
        let filter = StringFilter(property: .expansion, value: "Real", operation: .equal)
        XCTAssertFalse(filter.match(TestData.actionCard))
    }
}