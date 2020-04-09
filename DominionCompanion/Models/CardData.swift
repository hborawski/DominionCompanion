//
//  CardData.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
class CardData {
    public static let shared: CardData = CardData()
    
    var excludedCards: [Card] {
        get {
            guard
                let rawData = UserDefaults.standard.data(forKey: "excludedCards"),
                let cards = try? PropertyListDecoder().decode([Card].self, from: rawData)
            else { return [] }
            return cards
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "excludedCards")
            }
        }
    }
    
    let allCards: [Card]
    
    var kingdomCards: [Card]
    
    let allExpansions: [String]
    
    let allAttributes: [CardProperty]
    
    let allTypes: [String]
    
    let kingdomTypes: [String]
    
    let allLandmarks: [Card]
    
    let allEvents: [Card]
    
    let allProjects: [Card]
    
    // MARK: Maxes for creating picker inputs
    let maxPrice: Int
    let maxDebt: Int
    let maxActions: Int
    let maxBuys: Int
    let maxCards: Int
    let maxVictoryTokens: Int
    
    var cardsFromChosenExpansions: [Card] {
        get {
            let expansions = UserDefaults.standard.array(forKey: "expansions") as? [String] ?? self.allExpansions
            guard expansions.count > 0 else { return kingdomCards.filter { !excludedCards.contains($0) } }
            let cards = self.kingdomCards.filter { expansions.contains($0.expansion) && !excludedCards.contains($0) }
            return cards
        }
    }
    
    init() {
        if
            let path = Bundle.main.path(forResource: "cards", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let decodedData = try? JSONDecoder().decode([Card].self, from: data)
        {
            self.allCards = decodedData.sorted(by: Utilities.alphabeticSort(card1:card2:))
        } else {
            self.allCards = []
        }
        self.kingdomCards = self.allCards.filter { (card: Card) -> Bool in
            return Set(Constants.nonKingdomTypes).intersection(Set(card.types)).count == 0
        }
        
        self.maxPrice = self.kingdomCards.map({$0.cost}).max(by: {$0<$1}) ?? 0
        self.maxDebt = self.kingdomCards.map({$0.debt}).max(by: {$0<$1}) ?? 0
        self.maxActions = self.kingdomCards.map({$0.actions}).max(by: {$0<$1}) ?? 0
        self.maxBuys = self.kingdomCards.map({$0.buys}).max(by: {$0<$1}) ?? 0
        self.maxCards = self.kingdomCards.map({$0.cards}).max(by: {$0<$1}) ?? 0
        self.maxVictoryTokens = self.kingdomCards.map({$0.tokens.victory}).max(by: {$0<$1}) ?? 0

        self.allExpansions = Array(Set(self.kingdomCards.map({$0.expansion}).filter { $0 != "" })).sorted()
        self.allLandmarks = self.allCards.filter { $0.types.contains("Landmark") }
        self.allEvents = self.allCards.filter { $0.types.contains("Event") }
        self.allProjects = self.allCards.filter { $0.types.contains("Project") }
        self.allAttributes = CardProperty.allCases
        self.kingdomTypes = self.kingdomCards.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            return Array(Set(allTypes).union(Set(types)))
        }).sorted()
        self.allTypes = self.allCards.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            return Array(Set(allTypes).union(Set(types)))
        }).sorted()
        
    }
}
