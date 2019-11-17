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
        guard self.hasMatch(cards) else { return false }
        let setValue = self.matchingCards(cards).count
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
            return setValue > value
        case .notEqual:
            return setValue != value
        }
    }
}
