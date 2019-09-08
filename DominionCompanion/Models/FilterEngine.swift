//
//  FilterEngine.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class FilterEngine {
    public static let shared : FilterEngine = FilterEngine()
    
    // MARK: Constant Properties
    let cardData : [Card] = CardData.shared.cardData
    
    // MARK: Mutable Properties
    var filters: [SetFilter] = []
    
    var matchAnyFilter: [Card] {
        get {
            let cards = filters.reduce([]) { (cards: [Card], filter: SetFilter) -> [Card] in
                let cardSet = Set(cards)
                let filtered = filter.matchingCards(cardData)
                let filterSet = Set(filtered)
                return Array(cardSet.union(filterSet))
            }
            return cards
        }
    }
    
    init() {
    }
    
    // MARK: Public API
    func addFilter(_ filter: SetFilter) {
        self.filters.append(filter)
    }
    
    func removeFilter(_ index: Int) {
        self.filters.remove(at: index)
    }
    
    // MARK: Utility Methods
    func applyFilter(_ cards: [Card], _ filter: PropertyFilter) -> [Card] {
        return cards.filter{filter.match($0)}
    }
    
}
