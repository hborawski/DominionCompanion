//
//  SetBuilderModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

class SetBuilderModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    private let cardData: CardData
    
    @Published var rules: [SetRule] = []
    
    
    @Published var currentSet: [Card] = []
    
    init(_ cardData: CardData) {
        self.cardData = cardData
    }
    
    func shuffle() {
//        Just(Array(cardData.cardsFromChosenExpansions.shuffled()[0..<10])).receive(on: RunLoop.main).assign(to: \.currentSet, on: self).store(in: &bag)
        
        getMatchingSet([]) { result in
            switch result {
            case .success(let cards):
                Just(cards).receive(on: RunLoop.main).assign(to: \.currentSet, on: self).store(in: &self.bag)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getMatchingSet(_ pinned: [Card], _ completion: @escaping (Result<[Card], RuleEngineError>) -> Void) {
        guard pinned.count < 10, self.cardData.cardsFromChosenExpansions.count >= 10 else { return completion(.success(pinned)) }
        let cardCopy = self.cardData.cardsFromChosenExpansions
        guard rules.count > 0 else {
            return completion(.success(pinned + Array(cardCopy.shuffled()[0..<(10 - pinned.count)])))
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
            while finalSet.count < 10 {
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
                if (finalSet.count == 10 && satisfaction < 1.0) {
                    finalSet = pinned
                    satisfaction = 0.0
                    workingCards = cardCopy.shuffled()
                    ruleSatisfactions = self.rules.map { $0.satisfaction(pinned) }
                }
            }
            DispatchQueue.main.async {
                Logger.shared.d("Final Satisfaction: \(self.ruleSatisfaction(finalSet, self.rules))")
                Logger.shared.d(finalSet.map({$0.name}).joined(separator: "|"))
                completion(.success(finalSet))
            }
        }
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
