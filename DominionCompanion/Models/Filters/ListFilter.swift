//
//  ListFilter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation



struct ListFilter: PropertyFilter {
    static var availableOperations: [FilterOperation] = [
        .equal
    ]
    
    var property: CardProperty
    var value: String
    var stringValue: String
    var operation: FilterOperation
    
    init(property: CardProperty, value: String, operation: FilterOperation) {
        self.property = property
        self.value = value
        self.stringValue = "\(value)"
        self.operation = operation
    }
    
    func match(_ card: Card) -> Bool {
        guard let cardValue = card.getProperty(self.property) as? [String] else { return false }
        switch self.operation {
        case .equal:
            return cardValue.contains(value)
        default:
            return false
        }
    }
}
