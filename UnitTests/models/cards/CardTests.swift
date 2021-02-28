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
        let fateCard = CardData.shared.allCards.filter { $0.name == "Druid" }.first!
        let doomCard = CardData.shared.allCards.filter { $0.name == "Vampire" }.first!
        let looterCard = CardData.shared.allCards.filter { $0.name == "Cultist" }.first!
        let castleCard = CardData.shared.allCards.filter { $0.name == "Castles" }.first!
        let knightCards = CardData.shared.allCards.filter { $0.name == "Knights" }.first!

        XCTAssertEqual(fateCard.relatedCards.count, 12)
        XCTAssertEqual(doomCard.relatedCards.count, 13)
        XCTAssertEqual(looterCard.relatedCards.count, 5)
        XCTAssertEqual(castleCard.relatedCards.count, 8)
        XCTAssertEqual(knightCards.relatedCards.count, 10)
    }

    func testCanPin() {
        let supplyKingdomCard = CardData.shared.allCards.filter { $0.name == "Village" }.first!
        let nonSupplyKingdomCard = CardData.shared.allCards.filter { $0.name == "Grand Castle" }.first!
        let eventCard = CardData.shared.allCards.filter { $0.name == "Alms" }.first!
        let landmarkCard = CardData.shared.allCards.filter { $0.name == "Archive" }.first!
        let projectCard = CardData.shared.allCards.filter { $0.name == "Academy" }.first!
        let wayCard = CardData.shared.allCards.filter { $0.name == "Way of the Rat" }.first!

        XCTAssertEqual(supplyKingdomCard.canPin, true)
        XCTAssertEqual(nonSupplyKingdomCard.canPin, false)
        XCTAssertEqual(eventCard.canPin, true)
        XCTAssertEqual(landmarkCard.canPin, true)
        XCTAssertEqual(projectCard.canPin, true)
        XCTAssertEqual(wayCard.canPin, true)
    }

    func testPropertyGetter() {
        let village = CardData.shared.allCards.filter { $0.name == "Village" }.first!

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
        let village = CardData.shared.allCards.filter { $0.name == "Village" }.first!

        XCTAssertNotNil(village.image())
    }

    func testHashing() {
        let village = CardData.shared.allCards.filter { $0.name == "Village" }.first!
        let village2 = CardData.shared.allCards.filter { $0.name == "Village" }.first!

        XCTAssertEqual(village, village2)
    }
}
