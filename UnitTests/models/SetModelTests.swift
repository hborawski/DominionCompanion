//
//  SetModelTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 3/7/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

@testable import DominionCompanion

class SetModelTests: XCTestCase {
    override func setUp() {
        Settings.shared.colonies = false
        Settings.shared.shelters = false
    }
    func testSetModelExpansions() {
        let model = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Harbinger"),
            TestData.getCard("Fishing Village")
        ])

        XCTAssertEqual(model.expansions, ["Base", "Seaside"])
        XCTAssertEqual(model.expansionString, "Base Seaside")
    }

    func testSetModelNotInSupply() {
        let model = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Vampire")
        ])

        XCTAssertEqual(model.notInSupply.count, 1)
    }

    func testColoniesGetter() {
        let model = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Forge"),
            TestData.getCard("City"),
            TestData.getCard("Forge"),
            TestData.getCard("City"),
            TestData.getCard("Forge"),
            TestData.getCard("City"),
            TestData.getCard("Forge"),
            TestData.getCard("City"),
            TestData.getCard("Forge"),
            TestData.getCard("City")
        ])

        XCTAssertTrue(model.colonies)

        Settings.shared.colonies = true
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Village"),
            TestData.getCard("Fishing Village")
        ])

        XCTAssertTrue(model2.colonies)

        Settings.shared.colonies = false
        let model3 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Village"),
            TestData.getCard("Fishing Village")
        ])

        XCTAssertFalse(model3.colonies)
    }

    func testSheltersGetter() {
        let model = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Bandit Camp"),
            TestData.getCard("Altar"),
            TestData.getCard("Bandit Camp"),
            TestData.getCard("Altar"),
            TestData.getCard("Bandit Camp"),
            TestData.getCard("Altar"),
            TestData.getCard("Bandit Camp"),
            TestData.getCard("Altar"),
            TestData.getCard("Bandit Camp"),
            TestData.getCard("Altar")
        ])

        XCTAssertTrue(model.shelters)

        Settings.shared.shelters = true
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Bandit Camp")
        ])

        XCTAssertTrue(model2.shelters)

        Settings.shared.shelters = false
        let model3 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: [
            TestData.getCard("Village")
        ])

        XCTAssertFalse(model3.shelters)
    }

    func testSetModelGetters() {
        let set = [
            TestData.getCard("Druid"),
            TestData.getCard("Vampire"),
            TestData.getCard("Cultist"),
            TestData.getCard("Alchemist"),
            TestData.getCard("Forge"),
            TestData.getCard("City Quarter"),
            TestData.getCard("Recruiter"),
            TestData.getCard("Bishop"),
            TestData.getCard("Cobbler"),
            TestData.getCard("Butcher"),
            TestData.getCard("Island"),
            TestData.getCard("Native Village"),
            TestData.getCard("Pirate Ship"),
            TestData.getCard("Ranger")
        ]

        let model = SetModel(landmarks: [], events: [], projects: [], ways: [TestData.getCard("Way of the Worm")], cards: set)

        XCTAssertTrue(model.boons)
        XCTAssertTrue(model.hexes)
        XCTAssertTrue(model.ruins)
        XCTAssertTrue(model.potions)
        XCTAssertTrue(model.debt)
        XCTAssertTrue(model.victoryTokens)

        let mechanics = model.getAdditionalMechanics()

        XCTAssertTrue(mechanics.contains("Boons"))
        XCTAssertTrue(mechanics.contains("Hexes"))
        XCTAssertTrue(mechanics.contains("Ruins"))
        XCTAssertTrue(mechanics.contains("Exile Mat"))
        XCTAssertTrue(mechanics.contains("Tavern Mat"))
        XCTAssertTrue(mechanics.contains("Native Village Mat"))
        XCTAssertTrue(mechanics.contains("Island Mat"))
        XCTAssertTrue(mechanics.contains("Pirate Ship Mat"))

        let tokens = model.getTokens()

        XCTAssertTrue(tokens.contains("Debt Tokens"))
        XCTAssertTrue(tokens.contains("Coin Tokens"))
        XCTAssertTrue(tokens.contains("Coin Tokens (Villagers)"))
    }

    func testShareableSet() {
        let set = [
            TestData.getCard("Druid"),
            TestData.getCard("Vampire"),
            TestData.getCard("Cultist"),
            TestData.getCard("Alchemist"),
            TestData.getCard("Forge"),
            TestData.getCard("City Quarter"),
            TestData.getCard("Village"),
            TestData.getCard("Bishop"),
            TestData.getCard("Cobbler"),
            TestData.getCard("Butcher")
        ]

        let model = SetModel(
            landmarks: [TestData.getCard("Arena")],
            events: [TestData.getCard("Advance")],
            projects: [TestData.getCard("Academy")],
            ways: [TestData.getCard("Way of the Rat")],
            cards: set
        )

        let shareable = model.getShareable()

        XCTAssertEqual(model.cards.count, shareable.cards.count)
        XCTAssertEqual(model.events.count, shareable.events.count)
        XCTAssertEqual(model.landmarks.count, shareable.landmarks.count)
        XCTAssertEqual(model.projects.count, shareable.projects.count)
        XCTAssertEqual(model.ways.count, shareable.ways.count)

        let model2 = shareable.getSetModel()

        XCTAssertEqual(model2.cards.count, shareable.cards.count)
        XCTAssertEqual(model2.events.count, shareable.events.count)
        XCTAssertEqual(model2.landmarks.count, shareable.landmarks.count)
        XCTAssertEqual(model2.projects.count, shareable.projects.count)
        XCTAssertEqual(model2.ways.count, shareable.ways.count)
    }
}
