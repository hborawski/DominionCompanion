//
//  ListFilterTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

class ListFilterTest: XCTestCase {
    func testFilterMatches() {
        let filter = ListFilter(property: .type, value: "Action", operation: .equal)
        XCTAssert(filter.match(TestData.actionCard))
        XCTAssert(filter.match(TestData.actionDurationCard))
    }
    func testFilterDoesntMatch() {
        let filter = StringFilter(property: .expansion, value: "Treasure", operation: .equal)
        XCTAssertFalse(filter.match(TestData.actionCard))
    }
}
