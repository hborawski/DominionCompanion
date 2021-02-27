//
//  RuleTests.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class RuleTests: XCTestCase {
    func testEquality() {
        let rule1 = Rule(value: 1, operation: .equal, conditions: [])
        let rule2 = Rule(value: 1, operation: .equal, conditions: [])

        XCTAssertTrue(rule1 == rule1)
        XCTAssertFalse(rule1 == rule2)
    }

    func testDecode() {
        let json = """
        {
            "value": 1,
            "operation": "=",
            "conditions": []
        }
        """

        guard
            let data = json.data(using: .utf8),
            let rule = try? JSONDecoder().decode(Rule.self, from: data)
        else {
            return XCTFail()
        }

        XCTAssertEqual(rule.value, 1)
        XCTAssertEqual(rule.operation, .equal)
        XCTAssertEqual(rule.conditions, [])

    }

    func testEncode() {
        let rule = Rule(value: 1, operation: .equal, conditions: [])

        guard
            let data = try? JSONEncoder().encode(rule),
            let string = String(data: data, encoding: .utf8)
        else {
            return XCTFail()
        }

        XCTAssertTrue(string.contains("1"))
        XCTAssertTrue(string.contains("="))
    }

    func testInverseMatch() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")
        
        let rule = Rule(value: 1, operation: .greater, conditions: [condition])
        let set = [TestData.cost2Card]
        XCTAssert(rule.inverseMatch(set))

        let rule2 = Rule(value: 1, operation: .greaterOrEqual, conditions: [condition])
        XCTAssert(rule2.inverseMatch(set))
    }
}
