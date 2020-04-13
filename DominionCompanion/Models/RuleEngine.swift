//
//  FilterEngine.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit
enum RuleEngineError: Error {
    case notSatisfiable
    case tooManyAttempts
}
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
    
    init() {
        self.rules = self.loadPinnedRules()
    }
    
    init(_ savedRule: SavedRule) {
        self.rules = savedRule.rules
        self.savedRule = savedRule
    }
    
    // MARK: Public API
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping (Result<[Card], RuleEngineError>) -> Void) {
        guard pinned.count < 10, self.cardData.count >= 10 else { return completion(.success(pinned)) }
        let cardCopy = self.cardData
        guard rules.count > 0 else {
            return completion(.success(pinned + Array(cardCopy.shuffled()[0..<(10 - pinned.count)])))
        }
        guard rulesCanBeSatisfied(cardCopy, self.rules) else {
            print("Cant make a set with these rules")
            return completion(.failure(.notSatisfiable))
        }
        DispatchQueue.global(qos: .background).async {
            var workingCards = cardCopy.shuffled()
            var finalSet: [Card] = pinned
            var ruleSatisfactions: [Double] = self.rules.map { $0.satisfaction(pinned) }
            var satisfaction: Double = 0.0
            
            // How many attempts have been made for the current set
            // to prevent looping forever trying to find 1 more card but it's not possible
            var currentAttempts = 0
            
            // Total number of attempts to create a set
            var totalAttempts = 0
            while finalSet.count < 10 {
                guard totalAttempts < 100 else {
                    return completion(.failure(.tooManyAttempts))
                }
                guard currentAttempts < 5 else {
                    finalSet = pinned
                    satisfaction = 0.0
                    ruleSatisfactions = self.rules.map { $0.satisfaction(pinned) }
                    workingCards = cardCopy.shuffled()
                    currentAttempts = 0
                    continue
                }
                // If there is no next card, circle back to cards that have been attempted before
                guard let nextCard = workingCards.popLast() else {
                    workingCards = cardCopy.shuffled()
                    currentAttempts += 1
                    totalAttempts += 1
                    continue
                }
                
                // make sure we dont have the card already in the set (if it was pinned for example)
                guard !finalSet.contains(nextCard) else { continue }

                // The potential next version of the set being built
                let tempSet = finalSet + [nextCard]
                
                // Calculate satisfactions for each rule
                let newSatisfactions = self.rules.map { $0.satisfaction(tempSet) }
                
                let satisfactionDiff = newSatisfactions.enumerated().map { (index, sat) in
                    return sat - ruleSatisfactions[index]
                }
                
                let satisfactionDecreased: Bool = satisfactionDiff.first(where: { $0 < 0.0 }) != nil
                
                // If it doesn't break the rules
                // and the satisfaction is either already met, or has increased
                // then proceed with this set
                if
                    self.inverseMatchRules(tempSet, self.rules),
                    !satisfactionDecreased,
                    self.ruleSatisfaction(tempSet, self.rules) > satisfaction || satisfaction == 1.0
                {
                    print("Satisfaction: \(self.ruleSatisfaction(tempSet, self.rules))")
                    print("Adding card to set: \(nextCard.name)")
                    finalSet = tempSet
                    satisfaction = self.ruleSatisfaction(finalSet, self.rules)
                    ruleSatisfactions = newSatisfactions
                } else {
                    print("Card did not match set: \(nextCard.name), satisfaction: \(satisfaction), count: \(finalSet.count)")
                }
                // If we fill the set but not all the rules are statisfied
                // reset and try again
                if (finalSet.count == 10 && satisfaction < 1.0) {
                    finalSet = pinned
                    satisfaction = 0.0
                    workingCards = cardCopy.shuffled()
                    ruleSatisfactions = self.rules.map { $0.satisfaction(pinned) }
                }
            }
            DispatchQueue.main.async {
                print("Final Satisfaction: \(self.ruleSatisfaction(finalSet, self.rules))")
                print(finalSet.map({$0.name}).joined(separator: "|"))
                completion(.success(finalSet))
            }
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
    
    // MARK: Utility Methods
    func inverseMatchRules(_ cards: [Card], _ rules: [SetRule]) -> Bool {
        return rules.reduce(true) { (acc: Bool, cv: SetRule) -> Bool in
            return acc && cv.inverseMatch(cards)
        }
    }
    
    func ruleSatisfaction(_ cards: [Card], _ rules: [SetRule]) -> Double {
        let satisfactions = rules.compactMap { $0.satisfaction(cards) }
        return satisfactions.reduce(0.0, +) / Double(rules.count)
    }
    
    func rulesCanBeSatisfied(_ cards: [Card], _ rules: [SetRule]) -> Bool {
        return rules.first(where: { !$0.satisfiable(cards) }) == nil
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
    
    func saveRules(_ rules: [SavedRule]) {
        if let data = try? PropertyListEncoder().encode(rules) {
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
