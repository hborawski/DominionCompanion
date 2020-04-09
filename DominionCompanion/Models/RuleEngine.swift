//
//  FilterEngine.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class RuleEngine {
    public static let shared : RuleEngine = RuleEngine()
    var savedRule: SavedRule?
    
    var editing: Bool { savedRule != nil }
    
    var cardData : [Card] { CardData.shared.cardsFromChosenExpansions }
    
    var rules: [SetRule] = [] {
        didSet {
            if !editing {
                self.savePinnedRules()
            }
        }
    }
    
    var matchAnyRule: [Card] {
        let cardCopy = self.cardData
        guard rules.count > 0 else { return cardCopy }
        let cards = rules.reduce([]) { (cards: [Card], filter: SetRule) -> [Card] in
            let cardSet = Set(cards)
            let filtered = filter.matchingCards(cardCopy)
            let filterSet = Set(filtered)
            return Array(cardSet.union(filterSet))
        }
        return cards
    }
    
    var matchAllRules: [Card] {
        let cardCopy = self.cardData
        let cards = rules.reduce(cardCopy) { (cards: [Card], filter: SetRule) -> [Card] in
            let cardSet = Set(cards)
            let filtered = filter.matchingCards(cardCopy)
            let filterSet = Set(filtered)
            return Array(cardSet.intersection(filterSet))
        }
        return cards
    }
    
    var editingRule: SetRule?
    
    
    init() {
        self.rules = self.loadPinnedRules()
    }
    
    init(_ savedRule: SavedRule) {
        self.rules = savedRule.rules
        self.savedRule = savedRule
    }
    
    // MARK: Public API
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping ([Card]) -> Void) {
        guard pinned.count < 10 else { return completion(pinned) }
        let cardCopy = self.cardData
        guard cardCopy.count >= 10 else { return completion([]) }
        guard rules.count > 0 else {
            return completion(pinned + Array(cardCopy.shuffled()[0..<pinned.count]))
        }
        DispatchQueue.global(qos: .background).async {
            var workingCards = cardCopy.shuffled()
            var finalSet: [Card] = pinned
            var satisfaction: Double = 0.0
            while finalSet.count < 10 {
                guard let nextCard = workingCards.popLast() else {
                    workingCards = cardCopy.shuffled()
                    continue
                }
                print("Trying card: \(nextCard.name)")
                let tempSet = finalSet + [nextCard]
                if
                    self.inverseMatchRules(tempSet, self.rules),
                    (self.ruleSatisfaction(tempSet, self.rules) > satisfaction || satisfaction == 1.0)
                {
                    print("Satisfaction: \(self.ruleSatisfaction(tempSet, self.rules))")
                    print("Adding card to set: \(nextCard.name)")
                    finalSet = tempSet
                    satisfaction = self.ruleSatisfaction(finalSet, self.rules)
                } else {
                    print("Card did not match set: \(nextCard.name), satisfaction: \(satisfaction), count: \(finalSet.count)")
                }
                if (finalSet.count == 10 && satisfaction < 1.0) {
                    finalSet = pinned
                    satisfaction = 0.0
                    workingCards = cardCopy.shuffled()
                }
            }
            DispatchQueue.main.async {
                print("Final Satisfaction: \(self.ruleSatisfaction(finalSet, self.rules))")
                print(finalSet.map({$0.name}).joined(separator: "|"))
                completion(finalSet)
            }
//            var attempts = 0
//            let generator = CombinationGenerator<Card>(cardCopy.shuffled(), size: 10 - pinned.count)
//            var testSet = generator.next()
//            var finalSet: [Card] = []
//            let start = CACurrentMediaTime()
//            while let set = testSet {
//                finalSet = pinned + set
//                if self.matchesAllRules(finalSet, self.rules) {
//                    print("found set in \(CACurrentMediaTime() - start) seconds and \(attempts) attempts")
//                    break
//                }
//                testSet = generator.next()
//                attempts += 1
//            }
//            DispatchQueue.main.async {
//                completion(finalSet)
//            }
        }
    }
    
    func addRule(_ rule: SetRule) {
        self.rules.append(rule)
    }
    
    func removeRule(_ index: Int) {
        self.rules.remove(at: index)
    }
    
    func updateRule( _ index: Int, _ newRule: SetRule) {
        self.rules[index] = newRule
    }
    
    func getRule(_ index: Int) -> SetRule? {
        guard index < self.rules.count else { return nil }
        return self.rules[index]
    }
    
    // MARK: Utility Methods    
    func matchesAllRules(_ cards: [Card], _ rules: [SetRule]) -> Bool {
        return rules.reduce(true) { (acc: Bool, cv: SetRule) -> Bool in
            return acc && cv.match(cards)
        }
    }
    
    func inverseMatchRules(_ cards: [Card], _ rules: [SetRule]) -> Bool {
        return rules.reduce(true) { (acc: Bool, cv: SetRule) -> Bool in
            return acc && cv.inverseMatch(cards)
        }
    }
    
    func ruleSatisfaction(_ cards: [Card], _ rules: [SetRule]) -> Double {
        let satisfactions = rules.compactMap { $0.satisfaction(cards) }
//        print(satisfactions)
        return satisfactions.reduce(0.0, +) / Double(rules.count)
    }
}

// MARK: UserDefaults saving
extension RuleEngine {
    private func loadPinnedRules() -> [SetRule] {
        guard let rawData = UserDefaults.standard.data(forKey: Constants.SaveKeys.pinnedRules),
            let rules = try? PropertyListDecoder().decode([SetRule].self, from: rawData) else { return [] }
        return rules
    }
    
    private func savePinnedRules(_ filters: [SetRule]? = nil) {
        if let data = try? PropertyListEncoder().encode(filters ?? self.rules) {
            UserDefaults.standard.set(data, forKey: Constants.SaveKeys.pinnedRules)
        }
    }
    
    func loadSavedRules() -> [SavedRule] {
        guard
            let rawData = UserDefaults.standard.data(forKey: Constants.SaveKeys.savedRules),
            let rules = try? PropertyListDecoder().decode([SavedRule].self, from: rawData)
        else {
            return []
        }
        return rules
    }
    
    func saveRules(_ filters: [SavedRule]) {
        if let data = try? PropertyListEncoder().encode(filters) {
            UserDefaults.standard.set(data, forKey: Constants.SaveKeys.savedRules)
        }
    }
    
    func updateSavedRules(_ rule: SavedRule) {
        var rules = loadSavedRules()
        guard let index = rules.firstIndex(where: { r in r.uuid == rule.uuid }) else {
            return
        }
        rules[index] = rule
        saveRules(rules)
    }
}

// MARK: SavedFilter
struct SavedRule: Codable {
    var name: String
    var rules: [SetRule]
    var uuid: String = UUID().uuidString
}
