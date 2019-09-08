//
//  CardProperty.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

enum CardProperty: String, CaseIterable {
    static var allCases : [CardProperty] = [.cost, .name, .expansion, .type]
    case cost = "Cost"
    case name = "Name"
    case expansion = "Expansion"
    case type = "Type"
    
    var inputType: PropertyFilter.Type {
        get {
            switch self {
            case .cost:
                return NumberFilter.self
            case .name:
                return StringFilter.self
            case .expansion:
                return ListFilter.self
            case .type:
                return ListFilter.self
            }
        }
    }
    
    var all: [String] {
        get {
            switch self {
            case .cost:
                return []
            case .name:
                return []
            case .expansion:
                return CardData.shared.expansions
            case .type:
                return CardData.shared.allTypes
            }
        }
    }
}
