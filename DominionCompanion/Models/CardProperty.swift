//
//  CardProperty.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

enum CardProperty: String, Codable {
    static var allCases : [CardProperty] = [.cost, .actions, .buys, .cards, .expansion, .type, .trash]
    case cost = "Cost"
    case expansion = "Expansion"
    case type = "Type"
    case buys = "+ Buys"
    case actions = "+ Actions"
    case cards = "+ Cards"
    case trash = "Trash"
    
    
    
    var inputType: PropertyFilter.Type {
        get {
            switch self {
            case .cost:
                return NumberFilter.self
            case .actions:
                return NumberFilter.self
            case .buys:
                return NumberFilter.self
            case .cards:
                return NumberFilter.self
            case .expansion:
                return ListFilter.self
            case .type:
                return ListFilter.self
            case .trash:
                return BooleanFilter.self
            }
        }
    }
    
    var all: [String] {
        get {
            switch self {
            case .cost:
                return []
            case .actions:
                return []
            case .buys:
                return []
            case .cards:
                return []
            case .expansion:
                return CardData.shared.expansions
            case .type:
                return CardData.shared.allTypes
            case .trash:
                return ["true", "false"]
            }
        }
    }
}
