//
//  Filter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct SetFilter: Codable {
    var value: Int
    var operation: FilterOperation
    var propertyFilter: PropertyFilter
    
    init(value: Int, operation: FilterOperation, propertyFilter: PropertyFilter) {
        self.value = value
        self.operation = operation
        self.propertyFilter = propertyFilter
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(Int.self, forKey: .value)
        if let propertyFilter = try? values.decode(NumberFilter.self, forKey: .propertyFilter) {
            self.propertyFilter = propertyFilter
        } else if let propertyFilter = try? values.decode(ListFilter.self, forKey: .propertyFilter) {
            self.propertyFilter = propertyFilter
        } else {
            self.propertyFilter = try values.decode(StringFilter.self, forKey: .propertyFilter)
        }
        
        if let operationValue = try? values.decode(String.self, forKey: .operation),
            let operation = FilterOperation(rawValue: operationValue) {
            self.operation = operation
        } else {
            self.operation = .equal
        }
        operation = try values.decode(FilterOperation.self, forKey: .operation)
    }
    
    func encode(to encoder: Encoder) throws {
        var coder = encoder.container(keyedBy: CodingKeys.self)
        try coder.encode(value, forKey: .value)
        try coder.encode(operation, forKey: .operation)
        if let filter = propertyFilter as? NumberFilter {
            try coder.encode(filter, forKey: .propertyFilter)
        } else if let filter = propertyFilter as? ListFilter {
            try coder.encode(filter, forKey: .propertyFilter)
        } else if let filter = propertyFilter as? StringFilter {
            try coder.encode(filter, forKey: .propertyFilter)
        }
    }
    
    func matchingCards(_ cards: [Card]) -> [Card] {
        return cards.filter{propertyFilter.match($0)}
    }
    
    private func hasMatch(_ cards: [Card]) -> Bool {
        if let _ = cards.firstIndex(where: { (card: Card) -> Bool in
            let matched = propertyFilter.match(card)
            return matched
        }) {
            return true
        } else {
            return false
        }
//        return nil != cards.firstIndex { propertyFilter.match($0) }
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

