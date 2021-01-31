//
//  Rule.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class Condition: Codable, Hashable, Identifiable, ObservableObject {
    static func == (lhs: Condition, rhs: Condition) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var type: RuleType { property.inputType }
    @Published var property: CardProperty
    @Published var operation: FilterOperation
    @Published var comparisonValue: String
    
    init(property: CardProperty, operation: FilterOperation, comparisonValue: String) {
        self.property = property
        self.operation = operation
        self.comparisonValue = comparisonValue
    }
    
    enum ConditionCodingKeys: CodingKey {
        case property
        case operation
        case comparisonValue
    }
    required init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: ConditionCodingKeys.self)
        self.property = try container.decode(CardProperty.self, forKey: .property)
        self.operation = try container.decode(FilterOperation.self, forKey: .operation)
        self.comparisonValue = try container.decode(String.self, forKey: .comparisonValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConditionCodingKeys.self)
        try container.encode(self.property, forKey: .property)
        try container.encode(self.operation, forKey: .operation)
        try container.encode(self.comparisonValue, forKey: .comparisonValue)
    }
}

enum RuleType: Int, Codable {
    case number
    case boolean
    case string
    case list
    
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
            case .list:
                return [.equal, .notEqual]
            }
        }
    }
}

extension Condition {
    func matches(card: Card) -> Bool {
        switch self.type {
        case .boolean:
            return booleanMatches(card: card)
        case .number:
            return numberMatches(card: card)
        case .string:
            return stringMatches(card: card)
        case .list:
            return listMatches(card: card)
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
        case .notEqual:
            return cardValue != value
        default:
            return false
        }
    }
    
    private func stringMatches(card: Card) -> Bool {
        guard let cardValue = card.getProperty(self.property) as? String else { return false }
        switch self.operation {
        case .equal:
            return cardValue == self.comparisonValue
        case .notEqual:
            return cardValue != self.comparisonValue
        default:
            return false
        }
    }
    
    private func listMatches(card: Card) -> Bool {
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
