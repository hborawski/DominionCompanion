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
            TestData.getCard("Ranger"),
            TestData.getCard("Miser")
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

    func testAdditionalMechanicsBoons() {
        // Tracker should cause Boons to be included
        let set1 = [TestData.getCard("Tracker")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Boons"))
        
        // Vampire should not cause Boons to be included
        let set2 = [TestData.getCard("Vampire")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Boons"))
    }
    
    func testAdditionalMechanicsHexes() {
        // Werewolf should cause Hexes to be included
        let set1 = [TestData.getCard("Werewolf")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Hexes"))

        // Druid should not cause Hexes to be included
        let set2 = [TestData.getCard("Druid")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Hexes"))
    }
    
    func testAdditionalMechanicsRuins() {
        // Death Cart should cause Ruins to be included
        let set1 = [TestData.getCard("Death Cart")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Ruins"))

        // Pillage should not cause Ruins to be included
        let set2 = [TestData.getCard("Pillage")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Ruins"))
    }

    func testAdditionalMechanicsExileMat() {
        // Displace should cause Exile Mat to be included
        let set1 = [TestData.getCard("Displace")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Exile Mat"))

        // Paddock should not cause Exile Mat to be included
        let set2 = [TestData.getCard("Paddock")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Exile Mat"))
    }

    func testAdditionalMechanicsTavernMat() {
        // Guide should cause Tavern Mat to be included
        let set1 = [TestData.getCard("Guide")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Tavern Mat"))

        // Giant should not cause Tavern Mat to be included
        let set2 = [TestData.getCard("Giant")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Tavern Mat"))
    }

    func testAdditionalMechanicsIslandMat() {
        // Island should cause Island Mat to be included
        let set1 = [TestData.getCard("Island")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Island Mat"))

        // Native Village should not cause Island Mat to be included
        let set2 = [TestData.getCard("Native Village")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Island Mat"))
    }

    func testAdditionalMechanicsNativeVillageMat() {
        // Native Village should cause Native Village Mat to be included
        let set1 = [TestData.getCard("Native Village")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Native Village Mat"))

        // Pirate Ship should not cause Native Village Mat to be included
        let set2 = [TestData.getCard("Pirate Ship")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Native Village Mat"))
    }

    func testAdditionalMechanicsPirateShipMat() {
        // Pirate Ship should cause Pirate Ship Mat to be included
        let set1 = [TestData.getCard("Pirate Ship")]
        let model1 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set1)
        XCTAssertTrue(model1.getAdditionalMechanics().contains("Pirate Ship Mat"))

        // Island should not cause Pirate Ship Mat to be included
        let set2 = [TestData.getCard("Island")]
        let model2 = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: set2)
        XCTAssertFalse(model2.getAdditionalMechanics().contains("Pirate Ship Mat"))
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
