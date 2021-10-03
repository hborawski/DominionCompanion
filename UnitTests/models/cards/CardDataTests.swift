//
//  CardDataTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class CardDataTests: XCTestCase {
    func testTypeLoading() {
        let data = CardData()

        XCTAssertTrue(data.allLandmarks.count > 0)
        XCTAssertTrue(data.allEvents.count > 0)
        XCTAssertTrue(data.allProjects.count > 0)
        XCTAssertTrue(data.allWays.count > 0)
    }

    func testChoosingExpansions() {
        Settings.shared.chosenExpansions = []
        XCTAssertEqual(CardData.shared.cardsFromChosenExpansions.count, Set(CardData.shared.kingdomCards.map { $0.name }).count)

        Settings.shared.chosenExpansions = ["Base"]
        XCTAssertEqual(CardData.shared.cardsFromChosenExpansions.count, 26)

        Settings.shared.chosenExpansions = ["Intrigue", "Intrigue (1st Edition)"]
        XCTAssertEqual(CardData.shared.cardsFromChosenExpansions.count, 32)
    }
}
