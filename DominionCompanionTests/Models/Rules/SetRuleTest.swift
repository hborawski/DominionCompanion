//
//  SetRuleTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

class SetRuleTest: XCTestCase {
    func testMatch() {
        let cardRule = CardRule(type: .string, property: .expansion, operation: .equal, comparisonValue: "Test")
        
        let rule = SetRule(value: 1, operation: .greater, cardRules: [cardRule])
        
        XCTAssert(rule.match([TestData.actionCard, TestData.treasureCard]))
        XCTAssert(rule.match([TestData.actionCard, TestData.treasureCard, TestData.actionCardExpansion2]))
        XCTAssertFalse(rule.match([TestData.actionCardExpansion2, TestData.actionDurationCardExpansion2]))
    }
    
    func testInverseMatch() {
        let cardRule = CardRule(type: .number, property: .cost, operation: .equal, comparisonValue: "2")
        
        let rule = SetRule(value: 1, operation: .greater, cardRules: [cardRule])
        let set = [TestData.cost2Card]
        XCTAssert(rule.inverseMatch(set))
    }
}
