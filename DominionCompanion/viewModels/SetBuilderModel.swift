//
//  SetBuilderModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

enum RuleEngineError: Error {
    case notSatisfiable
    case tooManyAttempts
}

protocol RuleBuilder {
    var rules: [Rule] { get set }
    func removeRule(_: IndexSet)
    func addRule(_: Rule)
}

class SetBuilderModel: ObservableObject, RuleBuilder {
    public var bag = Set<AnyCancellable>()
    private let cardData: CardData

    private let onError: ((String) -> Void)?
    
    @Published var rules: [Rule] = Settings.shared.pinnedRules
    
    @Published var cards: [Card] = Settings.shared.currentCards
    
    @Published var pinnedCards: [Card] = Settings.shared.pinnedCards

    @Published var landscape: [Card] = Settings.shared.currentLandscape
    
    @Published var pinnedLandscape: [Card] = Settings.shared.pinnedLandscape
    
    var finalSet: SetModel {
        SetModel(
            landmarks: landscape.filter { $0.types.contains("Landmark")},
            events: landscape.filter { $0.types.contains("Event")},
            projects: landscape.filter { $0.types.contains("Project")},
            ways: landscape.filter { $0.types.contains("Way")},
            cards: cards
        )
    }
    
    init(_ cardData: CardData, onError: ((String) -> Void)? = nil ) {
        self.cardData = cardData
        self.onError = onError
        
        $pinnedCards.sink { (pinned) in
            // Only update if the newly pinned card is not already in the set of cards (pinned from search)
            if Set(pinned).intersection(Set(self.cards)).count != pinned.count {
                Just(Array(Set(pinned).union(Set(self.cards)))).receive(on: RunLoop.main).assign(to: \.cards, on: self).store(in: &self.bag)
            }
            Settings.shared.pinnedCards = pinned
        }.store(in: &bag)
        
        $pinnedLandscape.sink { (pinned) in
            if Set(pinned).intersection(Set(self.landscape)).count != pinned.count {
                Just(Array(Set(pinned).union(Set(self.landscape)))).receive(on: RunLoop.main).assign(to: \.landscape, on: self).store(in: &self.bag)
            }
            Settings.shared.pinnedLandscape = pinned
        }.store(in: &bag)
        
        // When it's updated, save to UserDefaults
        $rules.sink { rules in
            Settings.shared.pinnedRules = rules
        }.store(in: &bag)

        $cards.sink { (cards) in
            Settings.shared.currentCards = cards
        }.store(in: &bag)

        $landscape.sink { (cards) in
            Settings.shared.currentLandscape = cards
        }.store(in: &bag)
    }
    
    func pin(_ card: Card) {
        if Set(["Landmark", "Project", "Event", "Way"]).intersection(Set(card.types)).count == 0 {
            if pinnedCards.contains(card) {
                Just(pinnedCards.filter { $0.name != card.name}).receive(on: RunLoop.main).assign(to: \.pinnedCards, on: self).store(in: &bag)
            } else {
                Just(pinnedCards + [card]).receive(on: RunLoop.main).assign(to: \.pinnedCards, on: self).store(in: &bag)
            }
        } else {
            if pinnedLandscape.contains(card) {
                Just(pinnedLandscape.filter { $0.name != card.name}).receive(on: RunLoop.main).assign(to: \.pinnedLandscape, on: self).store(in: &bag)
            } else {
                Just(pinnedLandscape + [card]).receive(on: RunLoop.main).assign(to: \.pinnedLandscape, on: self).store(in: &bag)
            }
        }
    }

    func accept(model: SetModel) {
        Just([]).assign(to: \.pinnedCards, on: self).store(in: &bag)
        Just([]).assign(to: \.pinnedLandscape, on: self).store(in: &bag)
        Just(model.cards).assign(to: \.cards, on: self).store(in: &bag)
        Just(model.landmarks + model.events + model.projects + model.ways).assign(to: \.landscape, on: self).store(in: &bag)
    }
    
    func shuffle() {
        getMatchingSet(pinnedCards) { result in
            switch result {
            case .success(let cards):
                Just(cards).receive(on: RunLoop.main).assign(to: \.cards, on: self).store(in: &self.bag)
            case .failure(let error):
                switch error {
                case .notSatisfiable:
                    self.onError?("Current rules cannot be satisfied with the chosen expansions")
                case .tooManyAttempts:
                    self.onError?("Unable to build set in time, current rules may be too specific.")
                }
                Logger.shared.e(error.localizedDescription)
            }
        }
        
        Just(getLandscapeCards(pinnedLandscape)).receive(on: RunLoop.main).assign(to: \.landscape, on: self).store(in: &bag)
    }
    
    
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping (Result<[Card], RuleEngineError>) -> Void) {
        guard
            pinned.count < Settings.shared.maxKingdomCards,
            self.cardData.cardsFromChosenExpansions.count >= Settings.shared.maxKingdomCards
        else { return completion(.success(pinned)) }
        
        let cardCopy = self.cardData.cardsFromChosenExpansions
        guard rules.count > 0 else {
            var set = pinned
            for card in cardCopy.shuffled() {
                let tempSet = set + [card]
                guard Set(tempSet.map(\.expansion)).count <= Settings.shared.maxExpansions else { continue }
                set.append(card)
                if set.count == Settings.shared.maxKingdomCards {
                    break
                }
            }
            return completion(.success(set))
        }
        guard rulesCanBeSatisfied(cardCopy, self.rules) else {
            Logger.shared.w("A set cannot be made with the current rules")
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
            while finalSet.count < Settings.shared.maxKingdomCards {
                guard totalAttempts < 100 else {
                    Logger.shared.w("Too many attempts to create a set")
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

                guard Set(tempSet.map(\.expansion)).count <= Settings.shared.maxExpansions else { continue }
                
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
//                    self.inverseMatchRules(tempSet, self.rules),
                    !satisfactionDecreased,
                    self.ruleSatisfaction(tempSet, self.rules) > satisfaction || satisfaction == 1.0
                {
                    Logger.shared.t("Satisfaction: \(self.ruleSatisfaction(tempSet, self.rules))")
                    Logger.shared.t("Adding card to set: \(nextCard.name)")
                    finalSet = tempSet
                    satisfaction = self.ruleSatisfaction(finalSet, self.rules)
                    ruleSatisfactions = newSatisfactions
                } else {
                    Logger.shared.t("Card did not match set: \(nextCard.name), satisfaction: \(satisfaction), count: \(finalSet.count)")
                }
                // If we fill the set but not all the rules are statisfied
                // reset and try again
                if (finalSet.count == Settings.shared.maxKingdomCards && satisfaction < 1.0) {
                    finalSet = pinned
                    satisfaction = 0.0
                    workingCards = cardCopy.shuffled()
                    ruleSatisfactions = self.rules.map { $0.satisfaction(pinned) }
                }
            }
            DispatchQueue.main.async {
                Logger.shared.d("Final Satisfaction: \(self.ruleSatisfaction(finalSet, self.rules))")
                Logger.shared.i("Final Set: \(finalSet.map({$0.name}).joined(separator: "|"))")
                completion(.success(finalSet))
            }
        }
    }
    
    func getLandscapeCards(_ pinned: [Card]) -> [Card] {
        let target = Int.random(in: 0...Settings.shared.maxLandscape)
        guard target > 0 else { return pinned }
        let pool = (cardData.allEvents + cardData.allLandmarks + cardData.allProjects + cardData.allWays).filter({ (card) -> Bool in
            guard !Settings.shared.useAnyLandscape, Settings.shared.chosenExpansions.count > 0 else { return true }
            return Settings.shared.chosenExpansions.contains(card.expansion)
        }).shuffled().filter { !pinned.contains($0) }
        var landscapes: [Card] = pinned
        for card in pool {
            if areLandscapesValid(landscapes + [card]) {
                landscapes.append(card)
            }
            if landscapes.count >= target { break }
        }
        return landscapes
    }
    
    func areLandscapesValid(_ landscapes: [Card]) -> Bool {
        guard
            (landscapes.filter { $0.types.contains("Event") }).count <= Settings.shared.maxEvents,
            (landscapes.filter { $0.types.contains("Landmark") }).count <= Settings.shared.maxLandmarks,
            (landscapes.filter { $0.types.contains("Project") }).count <= Settings.shared.maxProjects,
            (landscapes.filter { $0.types.contains("Way") }).count <= Settings.shared.maxWays
        else { return false }
        return true
    }
    
    // MARK: Utility Methods
//    func inverseMatchRules(_ cards: [Card], _ rules: [Rule]) -> Bool {
//        return rules.reduce(true) { (acc: Bool, cv: Rule) -> Bool in
//            return acc && cv.inverseMatch(cards)
//        }
//    }
    
    func ruleSatisfaction(_ cards: [Card], _ rules: [Rule]) -> Double {
        let satisfactions = rules.compactMap { $0.satisfaction(cards) }
        return satisfactions.reduce(0.0, +) / Double(rules.count)
    }
    
    func rulesCanBeSatisfied(_ cards: [Card], _ rules: [Rule]) -> Bool {
        return rules.first(where: { !$0.satisfiable(cards) }) == nil
    }

    func removeRule(_ indexSet: IndexSet) {
        self.rules.remove(atOffsets: indexSet)
    }

    func addRule(_ rule: Rule) {
        if let index = rules.firstIndex(where: {$0.id == rule.id}) {
            rules[index] = rule
        } else {
            rules.append(rule)
        }
    }
}
