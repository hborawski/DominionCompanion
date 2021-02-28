//
//  RuleTypeTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class RuleTypeTests: XCTestCase {
    func testAvailableOperations() {
        XCTAssertEqual(RuleType.number.availableOperations, [.greater, .greaterOrEqual, .equal, .notEqual, .lessOrEqual, .less])
        XCTAssertEqual(RuleType.boolean.availableOperations, [.equal])
        XCTAssertEqual(RuleType.string.availableOperations, [.equal, .notEqual])
        XCTAssertEqual(RuleType.list.availableOperations, [.equal, .notEqual])
    }
}
