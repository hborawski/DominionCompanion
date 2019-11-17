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
    func testFilterMatches() {
        let filter = StringFilter(property: .expansion, value: "Test", operation: .equal)
        
        let rule = SetRule(value: 1, operation: .greater, propertyFilter: filter)
        
        XCTAssert(rule.match([TestData.actionCard, TestData.treasureCard]))
        XCTAssert(rule.match([TestData.actionCard, TestData.treasureCard, TestData.actionCardExpansion2]))
        XCTAssertFalse(rule.match([TestData.actionCardExpansion2, TestData.actionDurationCardExpansion2]))
    }
}
