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
    let card1 = Card(id: "1", cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Cantrip", text: "Example Card", expansion: "Test", types: ["Action"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    let card2 = Card(id: "2", cost: 5, debt: 0, potion: false, actions: 1, buys: 0, cards: 2, name: "Laboratory", text: "Example Card", expansion: "ATest", types: ["Action"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    let card3 = Card(id: "3", cost: 6, debt: 0, potion: false, actions: 0, buys: 0, cards: 0, name: "Gold", text: "Example Card", expansion: "Test", types: ["Treasure"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])
    let card4 = Card(id: "2", cost: 5, debt: 0, potion: false, actions: 1, buys: 0, cards: 2, name: "Laboratory", text: "Example Card", expansion: "ATest (1st Edition)", types: ["Action"], trash: false, exile: false, tokens: TestData.noTokens, supply: true, related: [])

    
    func testAlphabeticSort() {
        let expected = [card1, card3, card2]
        let actual = [card2, card1, card3].sorted(by: SortMode.alphabetical.sortFunction())
        XCTAssertEqual(expected, actual)
    }
    
    func testCostSort() {
        let expected = [card1, card2, card3]
        let actual = [card2, card1, card3].sorted(by: SortMode.cost.sortFunction())
        XCTAssertEqual(expected, actual)
    }

    func testExpansionSort() {
        let expected = [card2, card1, card3]
        let actual = [card3, card1, card2].sorted(by: SortMode.expansion.sortFunction())
        XCTAssertEqual(expected, actual)
    }

    func testDeduplicateByName() {
        let expected = ["Cantrip", "Gold", "Laboratory"]
        let actual = Utilities.deduplicateByName(cards: [card1, card2, card3, card4])
            .map { $0.name }.sorted()
        XCTAssertEqual(expected, actual)
    }
}
