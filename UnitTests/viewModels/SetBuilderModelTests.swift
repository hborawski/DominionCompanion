//
//  SetBuilderModelTests.swift
//  UnitTests
//
//  Created by Harris Borawski on 2/28/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import XCTest
import Combine
@testable import DominionCompanion

class SetBuilderModelTests: XCTestCase {
    override func setUp() {
        Settings.shared.pinnedCards = []
        Settings.shared.pinnedLandscape = []
        Settings.shared.pinnedRules = []
        Settings.shared.chosenExpansions = []
        Settings.shared.maxKingdomCards = 10
        Settings.shared.maxExpansions = 10
        Settings.shared.maxLandscape = 2
    }

    // MARK: Pinning Tests
    func testPinCard() {
        let data = CardData()

        let model = SetBuilderModel(data)

        let village = TestData.getCard("Village")

        let pinnedExpectation = expectation(description: "village pinned")

        model.$pinnedCards.sink { newPinned in
            if newPinned == [village] {
                pinnedExpectation.fulfill()
            }
        }.store(in: &model.bag)

        model.pin(village)

        wait(for: [pinnedExpectation], timeout: 1)
    }

    func testUnpinCard() {
        let data = CardData()

        let village = TestData.getCard("Village")

        Settings.shared.pinnedCards = [village]

        let model = SetBuilderModel(data)

        let pinnedExpectation = expectation(description: "village pinned")

        model.$pinnedCards.sink { newPinned in
            if newPinned == [] {
                pinnedExpectation.fulfill()
            }
        }.store(in: &model.bag)

        model.pin(village)

        wait(for: [pinnedExpectation], timeout: 1)
    }

    func testPinLandscape() {
        let data = CardData()

        let model = SetBuilderModel(data)

        let advance = TestData.getCard("Advance")

        let pinnedExpectation = expectation(description: "advance pinned")

        model.$pinnedLandscape.sink { newPinned in
            if newPinned == [advance] {
                pinnedExpectation.fulfill()
            }
        }.store(in: &model.bag)

        model.pin(advance)

        wait(for: [pinnedExpectation], timeout: 1)
    }

    func testUnpinLandscape() {
        let data = CardData()

        let advance = TestData.getCard("Advance")

        Settings.shared.pinnedLandscape = [advance]
        let model = SetBuilderModel(data)


        let pinnedExpectation = expectation(description: "advance pinned")

        model.$pinnedLandscape.sink { newPinned in
            if newPinned == [] {
                pinnedExpectation.fulfill()
            }
        }.store(in: &model.bag)

        model.pin(advance)

        wait(for: [pinnedExpectation], timeout: 1)
    }

    // MARK: Accept set model tests

    func testAcceptSetModel() {
        let data = CardData()

        let model = SetBuilderModel(data)

        let cards = [
            TestData.getCard("Village"),
            TestData.getCard("Fishing Village")
        ]

        let setmodel = SetModel(landmarks: [], events: [], projects: [], ways: [], cards: cards)

        let resetExpecation = expectation(description: "pinned cards reset")
        resetExpecation.expectedFulfillmentCount = 2
        let setExpectation = expectation(description: "cards set")
        model.$cards.sink { newCards in
            if newCards == cards {
                setExpectation.fulfill()
            }
        }.store(in: &model.bag)

        model.$pinnedCards.sink { newCards in
            if newCards == [] {
                resetExpecation.fulfill()
            }
        }.store(in: &model.bag)

        model.accept(model: setmodel)

        wait(for: [resetExpecation, setExpectation], timeout: 1)
    }

    // MARK: shuffle tests

    func testShuffle() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let cards = expectation(description: "cards set")
        cards.expectedFulfillmentCount = 2
        let landscape = expectation(description: "landscape set")
        landscape.expectedFulfillmentCount = 2
        model.$cards.sink { _ in
            cards.fulfill()
        }.store(in: &model.bag)

        model.$landscape.sink { _ in
            landscape.fulfill()
        }.store(in: &model.bag)

        model.shuffle()

        wait(for: [cards, landscape], timeout: 1)
    }

    func testShuffleError() {
        let data = CardData()
        let error = expectation(description: "error sent")
        let model = SetBuilderModel(data) { _ in
            error.fulfill()
        }

        model.addRule(Rule(value: 10, operation: .greater, conditions: [Condition(property: .cost, operation: .greater, comparisonValue: "11")]))

        model.shuffle()

        wait(for: [error], timeout: 1)
    }

    // MARK: GetMatchingRules tests

    // Should just return random cards
    func testGetMatchingSetNoRules() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success:
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetImpossibleRule() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let rule = Rule(value: 10, operation: .greater, conditions: [
            Condition(property: .cost, operation: .greater, comparisonValue: "10")
        ])

        model.addRule(rule)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                switch error {
                case .notSatisfiable:
                    expecation.fulfill()
                default:
                    XCTFail()
                }
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetOneRule() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let rule = Rule(value: 1, operation: .greater, conditions: [
            Condition(property: .actions, operation: .greaterOrEqual, comparisonValue: "2")
        ])

        model.addRule(rule)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                guard cards.first(where: { $0.actions >= 2}) != nil else { return XCTFail() }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetOneRuleMultipleConditions() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let rule = Rule(value: 1, operation: .greater, conditions: [
            Condition(property: .actions, operation: .greaterOrEqual, comparisonValue: "2"),
            Condition(property: .cards, operation: .greater, comparisonValue: "1")
        ])

        model.addRule(rule)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                guard cards.first(where: { $0.actions >= 2 && $0.cards > 1}) != nil else { return XCTFail() }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetMultipleRules() {
        let data = CardData()
        let model = SetBuilderModel(data)

        let rule = Rule(value: 1, operation: .greater, conditions: [
            Condition(property: .actions, operation: .greaterOrEqual, comparisonValue: "2"),
            Condition(property: .cards, operation: .greater, comparisonValue: "1")
        ])

        let rule2 = Rule(value: 3, operation: .greater, conditions: [
            Condition(property: .cost, operation: .greaterOrEqual, comparisonValue: "5")
        ])

        model.addRule(rule)
        model.addRule(rule2)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                guard cards.first(where: { $0.actions >= 2 && $0.cards > 1}) != nil else { return XCTFail() }
                guard cards.filter({ $0.cost >= 5 }).count > 3 else {
                    return XCTFail()
                }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetWithExpansionLimit() {
        Settings.shared.maxExpansions = 3
        let data = CardData()
        let model = SetBuilderModel(data)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                guard Set(cards.map(\.expansion)).count <= 3 else { return XCTFail() }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    func testGetMatchingSetOneRuleWithExpansionLimit() {
        Settings.shared.maxExpansions = 3
        let data = CardData()
        let model = SetBuilderModel(data)

        let rule = Rule(value: 1, operation: .greater, conditions: [
            Condition(property: .actions, operation: .greaterOrEqual, comparisonValue: "2")
        ])

        model.addRule(rule)

        let expecation = XCTestExpectation(description: "Set Matches Rule")
        model.getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                guard
                    Set(cards.map(\.expansion)).count <= 3,
                    cards.first(where: { $0.actions >= 2}) != nil
                else { return XCTFail() }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 20) // long timeout because github actions is on the slower side
    }

    // MARK: getLandscapeCards tests

    func testGetLandscapeCards() {
        let data = CardData()
        let model = SetBuilderModel(data)

        var sets: [[Card]] = []
        for _ in 0...100 {
            sets.append(model.getLandscapeCards([]))
        }

        let distribution = Set(sets.map(\.count))

        XCTAssertTrue(distribution.contains(0))
        XCTAssertTrue(distribution.contains(1))
        XCTAssertTrue(distribution.contains(2))
    }
}
