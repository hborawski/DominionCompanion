//
//  RecommendedSetsTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class RecommendedSetsTests: XCTestCase {
    func testRecommendedSetsLoad() {
        XCTAssertTrue(RecommendedSets.shared.sets.count > 0)
    }
}
