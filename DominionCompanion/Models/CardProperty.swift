//
//  CardProperty.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

enum CardProperty: String, Codable {
    static var allCases : [CardProperty] = [.cost, .debt, .actions, .buys, .cards, .expansion, .type, .trash, .victoryTokens]
    case cost = "Cost"
    case debt = "Debt"
    case expansion = "Expansion"
    case type = "Type"
    case buys = "+ Buys"
    case actions = "+ Actions"
    case cards = "+ Cards"
    case trash = "Trash"
    case victoryTokens = "Victory Tokens"
    
    
    
    var inputType: PropertyFilter.Type {
        get {
            switch self {
            case .cost:
                return NumberFilter.self
            case .debt:
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
            case .victoryTokens:
                return NumberFilter.self
            }
        }
    }
    
    var all: [String] {
        get {
            switch self {
            case .cost:
                return Array(0...CardData.shared.maxPrice).map { "\($0)" }
            case .debt:
                return Array(0...CardData.shared.maxDebt).map { "\($0)" }
            case .actions:
                return Array(0...CardData.shared.maxActions).map { "\($0)" }
            case .buys:
                return Array(0...CardData.shared.maxBuys).map { "\($0)" }
            case .cards:
                return Array(0...CardData.shared.maxCards).map { "\($0)" }
            case .expansion:
                return CardData.shared.allExpansions
            case .type:
                return CardData.shared.kingdomTypes
            case .trash:
                return ["true", "false"]
            case .victoryTokens:
                return Array(0...CardData.shared.maxCards).map { "\($0)" }
            }
        }
    }
}
