//
//  SetRule.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class Rule: Codable, Hashable, ObservableObject, Identifiable {
    var id = UUID()
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum SetRuleCodingKeys: CodingKey {
        case value
        case operation
        case conditions
    }
    required init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: SetRuleCodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
        self.operation = try container.decode(FilterOperation.self, forKey: .operation)
        self.conditions = try container.decode([Condition].self, forKey: .conditions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SetRuleCodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.conditions, forKey: .conditions)
    }
    
    init(value: Int, operation: FilterOperation, conditions: [Condition]) {
        self.value = value
        self.operation = operation
        self.conditions = conditions
    }

    @Published var value: Int
    @Published var operation: FilterOperation
    @Published var conditions: [Condition]
    
    func matchingCards(_ cards: [Card]) -> [Card] {
        return conditions.reduce(cards) { (cards, rule) -> [Card] in
            return cards.filter { rule.matches(card: $0) }
        }
    }

    /**
     Checks if the given set of cards won't violate the Conditions / value
     - parameters:
        - cards: The set of cards to check against
     - returns: Whether or not the set of cards violates the rules
     */
    func inverseMatch(_ cards: [Card]) -> Bool {
        let setValue = self.matchingCards(cards).count
        let comparisonValue = Settings.shared.maxKingdomCards - value
        switch self.operation {
        case .greater:
            return setValue <= (Settings.shared.maxKingdomCards - value)
        case .greaterOrEqual:
            return setValue <= (Settings.shared.maxKingdomCards - (value - 1))
        case .equal:
            return setValue != comparisonValue
        case .lessOrEqual:
            return setValue <= value
        case .less:
            return setValue < value
        case .notEqual:
            return setValue != value
        }
    }

    /**
     Calculates the satisfaction of the rule
     Satisfaction is represented as a Double where 0 has no rule satisfied
     and 1.0 all rules have their conditions met
     - parameters:
        - cards: The cards to check for satisfaction
     - returns: The satisfaction of the cards
     */
    func satisfaction(_ cards: [Card]) -> Double {
        let setValue = Double(self.matchingCards(cards).count)
        let desiredValue = Double(value)
        switch self.operation {
        case .greater:
            guard desiredValue > 0 else { return 1.0 }
            return setValue > desiredValue ? 1.0 : setValue / desiredValue
        case .greaterOrEqual:
            return setValue >= desiredValue ? 1.0 : setValue / desiredValue
        case .equal:
            guard desiredValue > 0 else { return setValue > 0 ? 0.0 : 1.0 }
            return setValue > desiredValue ? desiredValue / setValue : setValue / desiredValue
        case .lessOrEqual:
            return setValue > desiredValue ? 0.0 : 1.0
        case .less:
            return setValue >= desiredValue ? 0.0 : 1.0
        case .notEqual:
            return setValue == desiredValue ? 0.0 : 1.0
        }
    }

    /**
     Checks whether or not a set of cards can satisfy the rules
     - parameters:
        - cards: The cards to check for satisfaction
     - returns: Whether or not the cards can satisfy the rules
     */
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
