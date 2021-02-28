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

    // MARK: Inverted Match Testing
    // Checks to see if the set violates the rule
    func testSatisfactionGreater() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")
        
        let rule = Rule(value: 2, operation: .greater, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 1.0)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card
        ]), 0.5)
    }
    func testSatisfactionGreaterOrEqual() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")

        let rule = Rule(value: 2, operation: .greaterOrEqual, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 1.0)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card
        ]), 0.5)
    }

    func testSatisfactionEqual() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")

        let rule = Rule(value: 2, operation: .equal, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card
        ]), 0.5)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 2/3)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 1.0)
    }

    func testSatisfactionLessOrEqual() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")

        let rule = Rule(value: 2, operation: .lessOrEqual, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 1.0)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 0.0)
    }

    func testSatisfactionLess() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")
        let rule = Rule(value: 2, operation: .less, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card
        ]), 1.0)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 0.0)
    }

    func testSatisfactionNotEqual() {
        let condition = Condition(property: .cost, operation: .equal, comparisonValue: "2")
        let rule = Rule(value: 2, operation: .notEqual, conditions: [condition])
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card
        ]), 1.0)
        XCTAssertEqual(rule.satisfaction([
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost3Card,
            TestData.cost2Card,
            TestData.cost2Card
        ]), 0.0)
    }
}
