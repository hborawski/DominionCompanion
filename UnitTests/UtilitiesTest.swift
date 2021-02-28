//
//  UtilitiesTest.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest

@testable import DominionCompanion

class UtilitiesTest: XCTestCase {
    let card1 = Card(cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Cantrip", text: "Example Card", expansion: "Test", types: ["Action"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    let card2 = Card(cost: 5, debt: 0, potion: false, actions: 1, buys: 0, cards: 2, name: "Laboratory", text: "Example Card", expansion: "Test", types: ["Action"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    let card3 = Card(cost: 6, debt: 0, potion: false, actions: 0, buys: 0, cards: 0, name: "Gold", text: "Example Card", expansion: "Test", types: ["Treasure"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    
    func testAlphabeticSort() {
        let expected = [card1, card3, card2]
        let actual = [card2, card1, card3].sorted(by: Utilities.alphabeticSort(card1:card2:))
        XCTAssertEqual(expected, actual)
    }
    
    func testCostSort() {
        let expected = [card1, card2, card3]
        let actual = [card2, card1, card3].sorted(by: Utilities.priceSort(card1:card2:))
        XCTAssertEqual(expected, actual)
    }
}
