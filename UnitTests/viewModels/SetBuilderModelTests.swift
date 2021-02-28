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
    }

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

        wait(for: [expecation], timeout: 2)
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

        wait(for: [expecation], timeout: 2)
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

        wait(for: [expecation], timeout: 2)
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

        wait(for: [expecation], timeout: 2)
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
                guard cards.filter({ $0.cost >= 5 }).count > 3 else { return XCTFail() }
                expecation.fulfill()
            case .failure:
                XCTFail()
            }
        }

        wait(for: [expecation], timeout: 2)
    }
}
