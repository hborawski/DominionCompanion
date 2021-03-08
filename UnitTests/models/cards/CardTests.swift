//
//  CardTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class CardTests: XCTestCase {
    func testRelatedCards() {
        let regularCard = TestData.getCard("Village")
        let fateCard = TestData.getCard("Druid")
        let doomCard = TestData.getCard("Vampire")
        let looterCard = TestData.getCard("Cultist")
        let castleCard = TestData.getCard("Castles")
        let knightCards = TestData.getCard("Knights")

        XCTAssertEqual(regularCard.relatedCards.count, 0)
        XCTAssertEqual(fateCard.relatedCards.count, 12)
        XCTAssertEqual(doomCard.relatedCards.count, 13)
        XCTAssertEqual(looterCard.relatedCards.count, 5)
        XCTAssertEqual(castleCard.relatedCards.count, 8)
        XCTAssertEqual(knightCards.relatedCards.count, 10)
    }

    func testCanPin() {
        let supplyKingdomCard = TestData.getCard("Village")
        let nonSupplyKingdomCard = TestData.getCard("Grand Castle")
        let eventCard = TestData.getCard("Alms")
        let landmarkCard = TestData.getCard("Archive")
        let projectCard = TestData.getCard("Academy")
        let wayCard = TestData.getCard("Way of the Rat")

        XCTAssertEqual(supplyKingdomCard.canPin, true)
        XCTAssertEqual(nonSupplyKingdomCard.canPin, false)
        XCTAssertEqual(eventCard.canPin, true)
        XCTAssertEqual(landmarkCard.canPin, true)
        XCTAssertEqual(projectCard.canPin, true)
        XCTAssertEqual(wayCard.canPin, true)
    }

    func testPropertyGetter() {
        let village = TestData.getCard("Village")

        XCTAssertEqual(village.getProperty(.cost) as? Int, 3)
        XCTAssertEqual(village.getProperty(.debt) as? Int, 0)
        XCTAssertEqual(village.getProperty(.potion) as? Bool, false)
        XCTAssertEqual(village.getProperty(.actions) as? Int, 2)
        XCTAssertEqual(village.getProperty(.buys) as? Int, 0)
        XCTAssertEqual(village.getProperty(.cards) as? Int, 1)
        XCTAssertEqual(village.getProperty(.expansion) as? String, "Base")
        XCTAssertEqual(village.getProperty(.type) as? [String], ["Action"])
        XCTAssertEqual(village.getProperty(.trash) as? Bool, false)
        XCTAssertEqual(village.getProperty(.exile) as? Bool, false)
        XCTAssertEqual(village.getProperty(.victoryTokens) as? Int, 0)
        XCTAssertEqual(village.getProperty(.coinTokens) as? Int, 0)
    }

    func testImageLoading() {
        let village = TestData.getCard("Village")

        XCTAssertNotNil(village.image())
    }

    func testHashing() {
        let village = TestData.getCard("Village")
        let village2 = TestData.getCard("Village")

        XCTAssertEqual(village, village2)
    }
}
