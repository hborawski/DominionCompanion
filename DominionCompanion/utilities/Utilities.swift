//
//  Utilities.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class Utilities {    
    public static func alphabeticSort(card1: Card, card2: Card) -> Bool {
        return card1.name <= card2.name
    }
    
    public static func priceSort(card1: Card, card2: Card) -> Bool {
        return card1.cost <= card2.cost
    }
    
    
    public static func sortByExpansionAndName(card1: Card, card2: Card) -> Bool {
        return card1.expansion == card2.expansion ? Utilities.alphabeticSort(card1: card1, card2: card2) : (card1.expansion < card2.expansion)
    }

    public static func deduplicateByName(cards: [Card]) -> [Card] {
        var cardNames = Set<String>()
        var deduped = Array<Card>()
        for card in cards {
            if cardNames.insert(card.name).inserted {
                deduped.append(card)
            }
        }
        return deduped
    }
}

enum SortMode: String, CaseIterable {
    case alphabetical
    case cost
    case expansion
}

extension SortMode {
    func sortFunction() -> (Card, Card) -> Bool {
        switch self {
        case .alphabetical:
            return Utilities.alphabeticSort(card1:card2:)
        case .cost:
            return Utilities.priceSort(card1:card2:)
        case .expansion:
            return Utilities.sortByExpansionAndName(card1:card2:)
        }
    }
}
