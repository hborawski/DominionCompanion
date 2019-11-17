//
//  Rule.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct CardRule: Codable {
    var type: RuleType
    var property: CardProperty
    var operation: FilterOperation
    var comparisonValue: String
}

enum RuleType: Int, Codable {
    case number
    case boolean
    case string
    
    var availableOperations: [FilterOperation] {
        get {
            switch self {
            case .number:
                return [
                    .greater,
                    .greaterOrEqual,
                    .equal,
                    .notEqual,
                    .lessOrEqual,
                    .less
                ]
            case .boolean:
                return [.equal]
            case .string:
                return [.equal, .notEqual]
            }
        }
    }
}

extension CardRule {
    func matches(card: Card) -> Bool {
        switch self.type {
        case .boolean:
            return booleanMatches(card: card)
        case .number:
            return numberMatches(card: card)
        case .string:
            return stringMatches(card: card)
        }
    }
    
    private func numberMatches(card: Card) -> Bool {
        guard
            let value = Int(self.comparisonValue),
            let cardValue = card.getProperty(self.property) as? Int
        else { return false }
        
        switch self.operation {
        case .greater:
            return cardValue > value
        case .greaterOrEqual:
            return cardValue >= value
        case .equal:
            return cardValue == value
        case .lessOrEqual:
            return cardValue <= value
        case .less:
            return cardValue < value
        case .notEqual:
            return cardValue != value
        }
    }
    
    private func booleanMatches(card: Card) -> Bool {
        guard
            let value = Bool(self.comparisonValue),
            let cardValue = card.getProperty(self.property) as? Bool
        else { return false }
        switch self.operation {
        case .equal:
            return cardValue == value
        default:
            return false
        }
    }
    
    private func stringMatches(card: Card) -> Bool {
        guard let cardValue = card.getProperty(self.property) as? [String] else { return false }
        switch self.operation {
        case .equal:
            return cardValue.contains(self.comparisonValue)
        case .notEqual:
            return !cardValue.contains(self.comparisonValue)
        default:
            return false
        }
    }
}
