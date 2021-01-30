//
//  SetRuleTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class SetRuleTest: XCTestCase {
    func testEquality() {
        let rule1 = SetRule(value: 1, operation: .equal, cardRules: [])
        let rule2 = SetRule(value: 1, operation: .equal, cardRules: [])

        XCTAssertTrue(rule1 == rule1)
        XCTAssertFalse(rule1 == rule2)
    }

    func testDecode() {
        let json = """
        {
            "value": 1,
            "operation": "=",
            "cardRules": []
        }
        """

        guard
            let data = json.data(using: .utf8),
            let rule = try? JSONDecoder().decode(SetRule.self, from: data)
        else {
            return XCTFail()
        }

        XCTAssertEqual(rule.value, 1)
        XCTAssertEqual(rule.operation, .equal)
        XCTAssertEqual(rule.cardRules, [])

    }

    func testEncode() {
        let rule = SetRule(value: 1, operation: .equal, cardRules: [])

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
        let cardRule = CardRule(property: .cost, operation: .equal, comparisonValue: "2")
        
        let rule = SetRule(value: 1, operation: .greater, cardRules: [cardRule])
        let set = [TestData.cost2Card]
        XCTAssert(rule.inverseMatch(set))
    }
}
