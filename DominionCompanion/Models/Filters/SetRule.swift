//
//  SetRule.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct SetRule: Codable {
    var value: Int
    var operation: FilterOperation
    var cardRules: [CardRule]
    
    func matchingCards(_ cards: [Card]) -> [Card] {
        return cardRules.reduce(cards) { (cards, rule) -> [Card] in
            return cards.filter { rule.matches(card: $0) }
        }
    }
    
    private func hasMatch(_ cards: [Card]) -> Bool {
        return nil != cardRules.firstIndex { rule in
            return nil != cards.firstIndex { rule.matches(card: $0) }
        }
    }
    
    func match(_ cards: [Card]) -> Bool {
        let setValue = self.matchingCards(cards).count
        guard setValue > 0 else { return false }
        switch self.operation {
        case .greater:
            return setValue > value
        case .greaterOrEqual:
            return setValue >= value
        case .equal:
            return setValue == value
        case .lessOrEqual:
            return setValue <= value
        case .less:
            return setValue < value
        case .notEqual:
            return setValue != value
        }
    }
    
    func inverseMatch(_ cards: [Card]) -> Bool {
        let setValue = self.matchingCards(cards).count
        let comparisonValue = 10 - value
        switch self.operation {
        case .greater:
            return setValue <= (10 - value)
        case .greaterOrEqual:
            return setValue <= (10 - (value - 1))
        case .equal:
            return setValue != comparisonValue
        case .lessOrEqual:
            return setValue <= value
        case .less:
            return setValue < value
        case .notEqual:
            return setValue == comparisonValue
        }
    }
    
    func satisfaction(_ cards: [Card]) -> Double {
        let setValue = Double(self.matchingCards(cards).count)
        let desiredValue = Double(value)
        switch self.operation {
        case .greater:
            return setValue > desiredValue ? 1.0 : setValue / desiredValue
        case .greaterOrEqual:
            return setValue >= desiredValue ? 1.0 : setValue / desiredValue
        case .equal:
            return setValue > desiredValue ? desiredValue / setValue : setValue / desiredValue
        case .lessOrEqual:
            return setValue > desiredValue ? 0.0 : 1.0
        case .less:
            return setValue >= desiredValue ? 0.0 : 1.0
        case .notEqual:
            return setValue / desiredValue
        }
    }
    
    func satisfiable(_ cards: [Card]) -> Bool {
        let setValue = self.matchingCards(cards).count
        switch self.operation {
        case .greater:
            return setValue > value
        case .greaterOrEqual:
            fallthrough
        case .equal:
            return setValue >= value
        case .lessOrEqual:
            fallthrough
        case .less:
            return setValue >= 0
        case .notEqual:
            return value == 0 ? setValue > 0 : true
        }
    }
}
