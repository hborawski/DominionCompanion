//
//  CardPropertyTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/27/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
@testable import DominionCompanion

class CardPropertyTests: XCTestCase {
    func testInputType() {
        XCTAssertEqual(CardProperty.cost.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.debt.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.potion.inputType, RuleType.boolean)
        XCTAssertEqual(CardProperty.actions.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.buys.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.cards.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.expansion.inputType, RuleType.string)
        XCTAssertEqual(CardProperty.type.inputType, RuleType.list)
        XCTAssertEqual(CardProperty.trash.inputType, RuleType.boolean)
        XCTAssertEqual(CardProperty.exile.inputType, RuleType.boolean)
        XCTAssertEqual(CardProperty.tavernMat.inputType, RuleType.boolean)
        XCTAssertEqual(CardProperty.victoryTokens.inputType, RuleType.number)
        XCTAssertEqual(CardProperty.coinTokens.inputType, RuleType.number)
    }

    func testRangeGeneration() {
        XCTAssertEqual(CardProperty.cost.all, ["0", "1", "2", "3", "4", "5", "6", "7", "8"])
        XCTAssertEqual(CardProperty.debt.all, ["0", "1", "2", "3", "4", "5", "6", "7", "8"])
        XCTAssertEqual(CardProperty.potion.all, ["true", "false"])
        XCTAssertEqual(CardProperty.actions.all, ["0", "1", "2", "3", "4"])
        XCTAssertEqual(CardProperty.buys.all, ["0", "1", "2"])
        XCTAssertEqual(CardProperty.cards.all, ["0", "1", "2", "3", "4", "5", "6", "7"])
        XCTAssertEqual(CardProperty.expansion.all, CardData.shared.allExpansions)
        XCTAssertEqual(CardProperty.type.all, CardData.shared.kingdomTypes)
        XCTAssertEqual(CardProperty.trash.all, ["true", "false"])
        XCTAssertEqual(CardProperty.exile.all, ["true", "false"])
        XCTAssertEqual(CardProperty.tavernMat.all, ["true", "false"])
        XCTAssertEqual(CardProperty.victoryTokens.all, ["0", "1", "2"])
        XCTAssertEqual(CardProperty.coinTokens.all, ["0", "1", "2"])
    }
}
