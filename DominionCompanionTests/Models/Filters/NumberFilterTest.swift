//
//  NumberFilterTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

class NumberFilterTest: XCTestCase {
    func testFilterMatchesEqual() {
        let filter = NumberFilter(property: .cost, value: "2", operation: .equal)
        XCTAssert(filter.match(TestData.cost2Card))
        XCTAssertFalse(filter.match(TestData.cost4Card))
    }
    func testFilterMatchesLessThanOrEqual() {
        let filter = NumberFilter(property: .cost, value: "3", operation: .lessOrEqual)
        XCTAssert(filter.match(TestData.cost2Card))
        XCTAssert(filter.match(TestData.cost3Card))
        XCTAssertFalse(filter.match(TestData.cost4Card))
    }
    func testFilterMatchesLess() {
        let filter = NumberFilter(property: .cost, value: "3", operation: .less)
        XCTAssert(filter.match(TestData.cost2Card))
        XCTAssertFalse(filter.match(TestData.cost3Card))
    }
    func testFilterMatchesGreater() {
        let filter = NumberFilter(property: .cost, value: "2", operation: .greater)
        XCTAssert(filter.match(TestData.cost3Card))
        XCTAssertFalse(filter.match(TestData.cost2Card))
    }
    func testFilterMatchesGreaterOrEqual() {
        let filter = NumberFilter(property: .cost, value: "3", operation: .greaterOrEqual)
        XCTAssert(filter.match(TestData.cost4Card))
        XCTAssert(filter.match(TestData.cost3Card))
        XCTAssertFalse(filter.match(TestData.cost2Card))
    }
    func testFilterMatchesNotEqual() {
        let filter = NumberFilter(property: .cost, value: "2", operation: .notEqual)
        XCTAssert(filter.match(TestData.cost3Card))
        XCTAssertFalse(filter.match(TestData.cost2Card))
    }
}
