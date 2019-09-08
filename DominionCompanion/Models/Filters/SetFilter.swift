//
//  Filter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct SetFilter {
    var value: Int
    var operation: FilterOperation
    var propertyFilter: PropertyFilter
    
    func matchingCards(_ cards: [Card]) -> [Card] {
        return cards.filter{propertyFilter.match($0)}
    }
    
    func match(_ cards: [Card]) -> Bool {
        let setValue = self.matchingCards(cards).count
        switch self.operation {
        case .greater:
            return value > setValue
        case .greaterOrEqual:
            return value >= setValue
        case .equal:
            return value == setValue
        case .lessOrEqual:
            return value <= setValue
        case .less:
            return value > setValue
        case .notEqual:
            return value != setValue
        }
    }
}

