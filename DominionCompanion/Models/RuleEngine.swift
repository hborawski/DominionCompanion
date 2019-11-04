//
//  FilterEngine.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class RuleEngine {
    public static let shared : RuleEngine = RuleEngine()
    var savedRule: SavedRule?
    
    var editing: Bool {
        get {
            return savedRule != nil
        }
    }
    
    var cardData : [Card] {
        get {
            return CardData.shared.cardsFromChosenExpansions
        }
    }
    
    var rules: [SetRule] = [] {
        didSet {
            if !editing {
                self.savePinnedRules()
            }
        }
    }
    
    var matchAnyRule: [Card] {
        get {
            guard rules.count > 0 else { return cardData }
            let cards = rules.reduce([]) { (cards: [Card], filter: SetRule) -> [Card] in
                let cardSet = Set(cards)
                let filtered = filter.matchingCards(cardData)
                let filterSet = Set(filtered)
                return Array(cardSet.union(filterSet))
            }
            return cards
        }
    }
    
    var matchAllRules: [Card] {
        get {
            let cards = rules.reduce(cardData) { (cards: [Card], filter: SetRule) -> [Card] in
                let cardSet = Set(cards)
                let filtered = filter.matchingCards(cardData)
                let filterSet = Set(filtered)
                return Array(cardSet.intersection(filterSet))
            }
            return cards
        }
    }
    
    
    init() {
        self.rules = self.loadPinnedRules()
    }
    
    init(_ savedRule: SavedRule) {
        self.rules = savedRule.rules
        self.savedRule = savedRule
    }
    
    // MARK: Public API
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping ([Card]) -> Void) {
        guard self.cardData.count >= 10 else {
            completion([])
            return
        }
        guard rules.count > 0 else {
            completion(Array(cardData.shuffled()[0...9]))
            return
        }
        DispatchQueue.global(qos: .background).async {
            var attempts = 0
            var testSet = Array(self.cardData.shuffled()[0...9])
            while !self.matchesAllFilters(testSet, self.rules) && attempts < 2000 {
                testSet = Array(self.cardData.shuffled()[0...9])
                attempts += 1
            }
            DispatchQueue.main.async {
                completion(testSet)
            }
        }
    }
    
    func addRule(_ filter: SetRule) {
        self.rules.append(filter)
    }
    
    func removeRule(_ index: Int) {
        self.rules.remove(at: index)
    }
    
    func updateFilter( _ index: Int, _ newFilter: SetRule) {
        self.rules[index] = newFilter
    }
    
    func getFilter(_ index: Int) -> SetRule? {
        guard index < self.rules.count else { return nil }
        return self.rules[index]
    }
    
    // MARK: Utility Methods
    func applyFilter(_ cards: [Card], _ filter: PropertyFilter) -> [Card] {
        return cards.filter{filter.match($0)}
    }
    
    func matchesAllFilters(_ cards: [Card], _ filters: [SetRule]) -> Bool {
        return filters.reduce(true) { (acc: Bool, cv: SetRule) -> Bool in
            return acc && cv.match(cards)
        }
    }
}

// MARK: UserDefaults saving
extension RuleEngine {
    private func loadPinnedRules() -> [SetRule] {
        guard let rawData = UserDefaults.standard.data(forKey: Constants.SaveKeys.pinnedRules),
            let filters = try? PropertyListDecoder().decode([SetRule].self, from: rawData) else { return [] }
        return filters
    }
    
    private func savePinnedRules(_ filters: [SetRule]? = nil) {
        if let data = try? PropertyListEncoder().encode(filters ?? self.rules) {
            UserDefaults.standard.set(data, forKey: Constants.SaveKeys.pinnedRules)
        }
    }
    
    func loadSavedRules() -> [SavedRule] {
        guard
            let rawData = UserDefaults.standard.data(forKey: Constants.SaveKeys.savedRules),
            let filters = try? PropertyListDecoder().decode([SavedRule].self, from: rawData)
        else {
            return []
        }
        return filters
    }
    
    func saveRules(_ filters: [SavedRule]) {
        if let data = try? PropertyListEncoder().encode(filters) {
            UserDefaults.standard.set(data, forKey: Constants.SaveKeys.savedRules)
        }
    }
    
    func updateSavedRules(_ filter: SavedRule) {
        var filters = loadSavedRules()
        guard let index = filters.firstIndex(where: { f in f.uuid == filter.uuid }) else {
            return
        }
        filters[index] = filter
        saveRules(filters)
    }
}

// MARK: SavedFilter
struct SavedRule: Codable {
    var name: String
    var rules: [SetRule]
    var uuid: String = UUID().uuidString
}
