//
//  ConditionTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 1/29/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

@testable import DominionCompanion

class ConditionTests: XCTestCase {
    func testEquality() {
        let rule1 = Condition(property: .actions, operation: .equal, comparisonValue: "1")
        let rule2 = Condition(property: .actions, operation: .equal, comparisonValue: "1")
        
        XCTAssertTrue(rule1 == rule1)
        XCTAssertFalse(rule1 == rule2)
    }
    
    func testDecode() {
        let json = """
        {
            "property": "+ Actions",
            "operation": "=",
            "comparisonValue": "1"
        }
        """
        guard
            let data = json.data(using: .utf8),
            let condition = try? JSONDecoder().decode(Condition.self, from: data)
        else {
            return XCTFail()
        }
        
        XCTAssertEqual(condition.property, .actions)
        XCTAssertEqual(condition.operation, .equal)
        XCTAssertEqual(condition.comparisonValue, "1")
    }
    
    func testEncode() {
        let rule = Condition(property: .actions, operation: .equal, comparisonValue: "1")
        
        guard
            let data = try? JSONEncoder().encode(rule),
            let string = String(data: data, encoding: .utf8)
        else {
            return XCTFail()
        }
        
        XCTAssertTrue(string.contains("+ Actions"))
        XCTAssertTrue(string.contains("="))
    }
    
    func testNumberMatching() {
        let greaterRule = Condition(property: .cost, operation: .greater, comparisonValue: "3")
        let greaterOrEqualRule = Condition(property: .cost, operation: .greaterOrEqual, comparisonValue: "3")
        let equalRule = Condition(property: .cost, operation: .equal, comparisonValue: "3")
        let lessOrEqualRule = Condition(property: .cost, operation: .lessOrEqual, comparisonValue: "3")
        let lessRule = Condition(property: .cost, operation: .less, comparisonValue: "3")
        let notEqualRule = Condition(property: .cost, operation: .notEqual, comparisonValue: "3")
        
        XCTAssertFalse(greaterRule.matches(card: TestData.cost3Card))
        XCTAssertTrue(greaterRule.matches(card: TestData.cost4Card))
        
        XCTAssertFalse(greaterOrEqualRule.matches(card: TestData.cost2Card))
        XCTAssertTrue(greaterOrEqualRule.matches(card: TestData.cost3Card))
        XCTAssertTrue(greaterOrEqualRule.matches(card: TestData.cost4Card))
        
        XCTAssertFalse(equalRule.matches(card: TestData.cost4Card))
        XCTAssertTrue(equalRule.matches(card: TestData.cost3Card))
        
        XCTAssertFalse(lessOrEqualRule.matches(card: TestData.cost4Card))
        XCTAssertTrue(lessOrEqualRule.matches(card: TestData.cost3Card))
        
        XCTAssertFalse(lessRule.matches(card: TestData.cost3Card))
        XCTAssertTrue(lessRule.matches(card: TestData.cost2Card))
        
        XCTAssertFalse(notEqualRule.matches(card: TestData.cost3Card))
        XCTAssertTrue(notEqualRule.matches(card: TestData.cost4Card))
        
    }
    
    func testBoolMatching() {
        let equalRule = Condition(property: .trash, operation: .equal, comparisonValue: "true")
        let notEqualRule = Condition(property: .trash, operation: .notEqual, comparisonValue: "true")
        let lessRule = Condition(property: .trash, operation: .less, comparisonValue: "true")
        
        XCTAssertFalse(equalRule.matches(card: TestData.actionCard))
        XCTAssertTrue(equalRule.matches(card: TestData.actionDurationCard))
        
        XCTAssertFalse(notEqualRule.matches(card: TestData.actionDurationCard))
        XCTAssertTrue(notEqualRule.matches(card: TestData.actionCard))
        
        XCTAssertFalse(lessRule.matches(card: TestData.actionDurationCard))
        XCTAssertFalse(lessRule.matches(card: TestData.actionCard))
    }
    
    func testStringMatching() {
        let equalRule = Condition(property: .expansion, operation: .equal, comparisonValue: "Test2")
        let notEqualRule = Condition(property: .expansion, operation: .notEqual, comparisonValue: "Test2")
        let lessRule = Condition(property: .expansion, operation: .less, comparisonValue: "Test2")
        
        XCTAssertFalse(equalRule.matches(card: TestData.actionCard))
        XCTAssertTrue(equalRule.matches(card: TestData.actionCardExpansion2))
        
        XCTAssertFalse(notEqualRule.matches(card: TestData.actionCardExpansion2))
        XCTAssertTrue(notEqualRule.matches(card: TestData.actionCard))
        
        XCTAssertFalse(lessRule.matches(card: TestData.actionCard))
        XCTAssertFalse(lessRule.matches(card: TestData.actionCardExpansion2))
    }
    
    func testListMatching() {
        let equalRule = Condition(property: .type, operation: .equal, comparisonValue: "Duration")
        let notEqualRule = Condition(property: .type, operation: .notEqual, comparisonValue: "Duration")
        let lessRule = Condition(property: .type, operation: .less, comparisonValue: "Duration")
        
        XCTAssertFalse(equalRule.matches(card: TestData.actionCard))
        XCTAssertTrue(equalRule.matches(card: TestData.actionDurationCard))
        
        XCTAssertFalse(notEqualRule.matches(card: TestData.actionDurationCard))
        XCTAssertTrue(notEqualRule.matches(card: TestData.actionCard))
        
        XCTAssertFalse(lessRule.matches(card: TestData.actionDurationCard))
        XCTAssertFalse(lessRule.matches(card: TestData.actionCard))
    }
}
