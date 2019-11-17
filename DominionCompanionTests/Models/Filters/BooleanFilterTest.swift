//
//  BooleanFilter.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

class BooleanFilterTest: XCTestCase {
    func testFilterMatches() {
        let filter = BooleanFilter(property: .trash, value: "true", operation: .equal)
        XCTAssert(filter.match(TestData.trashCard))
    }
    func testFilterDoesntMatch() {
        let filter = BooleanFilter(property: .trash, value: "true", operation: .equal)
        XCTAssertFalse(filter.match(TestData.actionCard))
    }
}
