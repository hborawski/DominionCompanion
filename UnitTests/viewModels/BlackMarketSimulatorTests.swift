//
//  BlackMarketSimulatorTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 6/18/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class BlackMarketSimulatorTests: XCTestCase {
    override func setUp() {
        Settings.shared.chosenExpansions = []
        Settings.shared.blackMarketShuffle = false
    }
    func testDiscardLoop() {
        Settings.shared.chosenExpansions = ["Base"]
        Settings.shared.blackMarketDeckSize = 3
        let sim = BlackMarketSimulator(set: [
            TestData.getCard("Laboratory"),
            TestData.getCard("Village"),
            TestData.getCard("Festival")
        ], data: CardData.shared)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 0)
        XCTAssertEqual(sim.discard.count, 0)

        sim.pass()

        XCTAssertEqual(sim.visibleCards.count, 0)
        XCTAssertEqual(sim.deck.count, 0)
        XCTAssertEqual(sim.discard.count, 3)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 0)
        XCTAssertEqual(sim.discard.count, 0)
    }

    func testDiscardLoopPartial() {
        Settings.shared.chosenExpansions = ["Base"]
        Settings.shared.blackMarketDeckSize = 4
        let sim = BlackMarketSimulator(set: [
            TestData.getCard("Laboratory"),
            TestData.getCard("Village"),
            TestData.getCard("Festival")
        ], data: CardData.shared)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 1)
        XCTAssertEqual(sim.discard.count, 0)

        sim.pass()

        XCTAssertEqual(sim.visibleCards.count, 0)
        XCTAssertEqual(sim.deck.count, 1)
        XCTAssertEqual(sim.discard.count, 3)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 1)
        XCTAssertEqual(sim.discard.count, 0)
    }

    func testDiscardShuffle() {
        Settings.shared.chosenExpansions = ["Base"]
        Settings.shared.blackMarketDeckSize = 3
        Settings.shared.blackMarketShuffle = true
        let sim = BlackMarketSimulator(set: [
            TestData.getCard("Laboratory"),
            TestData.getCard("Village"),
            TestData.getCard("Festival")
        ], data: CardData.shared)

        // Technically shuffling/randomization can produce the same order
        var shuffled = false
        var count = 0
        while !shuffled, count < 20 {
            sim.draw()

            let copy = sim.visibleCards.map(\.name).joined()

            sim.pass()

            sim.draw()

            if copy != sim.visibleCards.map(\.name).joined() {
                shuffled = true
            }
            count += 1
        }

        XCTAssertTrue(shuffled)

    }

    func testBuyCard() {
        Settings.shared.chosenExpansions = ["Base"]
        Settings.shared.blackMarketDeckSize = 4
        let sim = BlackMarketSimulator(set: [
            TestData.getCard("Laboratory"),
            TestData.getCard("Village"),
            TestData.getCard("Festival")
        ], data: CardData.shared)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 1)
        XCTAssertEqual(sim.discard.count, 0)

        sim.buy(sim.visibleCards[0])

        XCTAssertEqual(sim.visibleCards.count, 0)
        XCTAssertEqual(sim.deck.count, 1)
        XCTAssertEqual(sim.discard.count, 2)

        sim.draw()

        XCTAssertEqual(sim.visibleCards.count, 3)
        XCTAssertEqual(sim.deck.count, 0)
        XCTAssertEqual(sim.discard.count, 0)
    }
}
