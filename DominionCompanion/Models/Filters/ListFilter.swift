//
//  ListFilter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation



struct ListFilter: PropertyFilter, Codable {
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let propertyValue = try? values.decode(String.self, forKey: .property),
            let property = CardProperty(rawValue: propertyValue) {
            self.property = property
        } else {
            self.property = .cost
        }
        if let operationValue = try? values.decode(String.self, forKey: .operation),
            let operation = FilterOperation(rawValue: operationValue) {
            self.operation = operation
        } else {
            self.operation = .equal
        }
        value = try values.decode(String.self, forKey: .value)
        stringValue = try values.decode(String.self, forKey: .stringValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var coder = encoder.container(keyedBy: CodingKeys.self)
        try coder.encode(self.operation.rawValue, forKey: .operation)
        try coder.encode(self.value, forKey: .value)
        try coder.encode(self.stringValue, forKey: .stringValue)
        try coder.encode(self.property.rawValue, forKey: .property)
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
