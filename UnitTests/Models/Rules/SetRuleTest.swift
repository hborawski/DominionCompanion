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
    func testInverseMatch() {
        let cardRule = CardRule(property: .cost, operation: .equal, comparisonValue: "2")
        
        let rule = SetRule(value: 1, operation: .greater, cardRules: [cardRule])
        let set = [TestData.cost2Card]
        XCTAssert(rule.inverseMatch(set))
    }
}
