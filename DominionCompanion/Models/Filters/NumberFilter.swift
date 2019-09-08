//
//  NumberFilter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation


struct NumberFilter: PropertyFilter {
    static var availableOperations: [FilterOperation] = [
        .greater,
        .greaterOrEqual,
        .equal,
        .notEqual,
        .lessOrEqual,
        .less
    ]
    
    var property: CardProperty
    var value: Int
    var stringValue: String
    var operation: FilterOperation
    
    init(property: CardProperty, value: String, operation: FilterOperation) {
        self.property = property
        self.value = Int(value) ?? 0
        self.stringValue = "\(value)"
        self.operation = operation
    }
    
    func match(_ card: Card) -> Bool {
        guard let cardValue = card.getProperty(self.property) as? Int else { return false }
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
            return cardValue > value
        case .notEqual:
            return cardValue != value
        }
    }
}
