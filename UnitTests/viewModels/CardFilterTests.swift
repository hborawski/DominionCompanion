//
//  CardFilterTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 3/14/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

@testable import DominionCompanion

class CardFilterTests: XCTestCase {
    func testRuleUpdating() {
        let filter = CardFilter()

        filter.addRule(Rule(value: 0, operation: .less, conditions: []))

        XCTAssertEqual(filter.rule.value, 0)
        XCTAssertEqual(filter.rule.operation, .less)
        filter.addRule(Rule(value: 5, operation: .lessOrEqual, conditions: []))

        XCTAssertEqual(filter.rule.value, 5)
        XCTAssertEqual(filter.rule.operation, .lessOrEqual)

        filter.reset()

        XCTAssertEqual(filter.rule.value, 0)
        XCTAssertEqual(filter.rule.operation, .greater)
    }
}
