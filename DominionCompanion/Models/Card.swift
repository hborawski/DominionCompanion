//
//  Card.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

struct Tokens: Codable {
    var victory: Int
    var coin: Int
    var embargo: Bool
    var debt: Bool
    var journey: Bool
    var minusCard: Bool
    var minusCoin: Bool
    var plusCard: Bool
    var plusAction: Bool
    var plusBuy: Bool
    var plusCoin: Bool
    var minusCost: Bool
    var trashing: Bool
    var estate: Bool
}

struct Card: Codable {
    var cost: Int
    var debt: Int
    var actions: Int
    var buys: Int
    var cards: Int
    var name: String
    var text: String
    var expansion: String
    var types: [String]
    var trash: Bool
    var tokens: Tokens
    var supply: Bool
    var related: [String]
    
    var relatedCards: [Card] {
        get {
            return related.reduce([]) { (cards, related) -> [Card] in
                guard !CardData.shared.allTypes.contains(related) else {
                    return Array(Set(cards).union(Set(CardData.shared.allCards.filter { $0.types.contains(related) })))
                }
                return cards + CardData.shared.allCards.filter { $0.name == related }
            }
//            return CardData.shared.allCards.filter { (card) -> Bool in
//                return self.related.contains(card.name)
//            }
        }
    }
}

extension Card {
    public func getProperty(_ property: CardProperty) -> Any {
        switch property {
        case .cost:
            return self.cost
        case .debt:
            return self.debt
        case .actions:
            return self.actions
        case .buys:
            return self.buys
        case .cards:
            return self.cards
        case .expansion:
            return [self.expansion]
        case .type:
            return self.types
        case .trash:
            return self.trash
        case .victoryTokens:
            return self.tokens.victory
        }
    }
    
    public func image() -> UIImage? {
        guard
            let path = Bundle.main.path(forResource: "cards/\(self.name)", ofType: "jpg"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                return nil
        }
        return UIImage(data: data)
    }
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.cost)
    }
}
