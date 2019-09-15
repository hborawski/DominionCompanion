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
    
    var cardData : [Card] {
        get {
            return CardData.shared.chosenExpansions
        }
    }
    var filters: [SetFilter] = []
    
    var matchAnyFilter: [Card] {
        get {
            guard filters.count > 0 else { return cardData }
            let cards = filters.reduce([]) { (cards: [Card], filter: SetFilter) -> [Card] in
                let cardSet = Set(cards)
                let filtered = filter.matchingCards(cardData)
                let filterSet = Set(filtered)
                return Array(cardSet.union(filterSet))
            }
            return cards
        }
    }
    
    var matchAllFilters: [Card] {
        get {
            let cards = filters.reduce(cardData) { (cards: [Card], filter: SetFilter) -> [Card] in
                let cardSet = Set(cards)
                let filtered = filter.matchingCards(cardData)
                let filterSet = Set(filtered)
                return Array(cardSet.intersection(filterSet))
            }
            return cards
        }
    }
    
    
    init() {
        self.filters = self.loadFilters()
    }
    
    // MARK: Public API
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping ([Card]) -> Void) {
        guard self.cardData.count >= 10 else {
            completion([])
            return
        }
        guard filters.count > 0 else {
            completion(Array(cardData.shuffled()[0...9]))
            return
        }
        DispatchQueue.global(qos: .background).async {
            var attempts = 0
            var testSet = Array(self.cardData.shuffled()[0...9])
            while !self.matchesAllFilters(testSet, self.filters) && attempts < 2000 {
                testSet = Array(self.cardData.shuffled()[0...9])
                attempts += 1
            }
            DispatchQueue.main.async {
                completion(testSet)
            }
        }
    }
    
    func addFilter(_ filter: SetFilter) {
        self.filters.append(filter)
        self.saveFilters()
    }
    
    func removeFilter(_ index: Int) {
        self.filters.remove(at: index)
        self.saveFilters()
    }
    
    func updateFilter( _ index: Int, _ newFilter: SetFilter) {
        self.filters[index] = newFilter
        self.saveFilters()
    }
    
    func getFilter(_ index: Int) -> SetFilter? {
        guard index < self.filters.count else { return nil }
        return self.filters[index]
    }
    
    // MARK: Utility Methods
    func applyFilter(_ cards: [Card], _ filter: PropertyFilter) -> [Card] {
        return cards.filter{filter.match($0)}
    }
    
    func matchesAllFilters(_ cards: [Card], _ filters: [SetFilter]) -> Bool {
        return filters.reduce(true) { (acc: Bool, cv: SetFilter) -> Bool in
            return acc && cv.match(cards)
        }
    }
    
    private func loadFilters() -> [SetFilter] {
        guard let rawData = UserDefaults.standard.data(forKey: "savedFilters"),
            let filters = try? PropertyListDecoder().decode([SetFilter].self, from: rawData) else { return [] }
        return filters
    }
    
    private func saveFilters() {
        if let data = try? PropertyListEncoder().encode(self.filters) {
            UserDefaults.standard.set(data, forKey: "savedFilters")
        }
    }
}
