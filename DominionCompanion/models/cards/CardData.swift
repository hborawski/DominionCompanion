//
//  CardData.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

class CardData: ObservableObject {
    public static let shared: CardData = CardData()
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.savedExcludedCards)
    var excludedCards: [Card] = []
    
    @Published var excluded: [Card] = []
    
    let allCards: [Card]
    
    var kingdomCards: [Card]
    
    let allExpansions: [String]
    
    let allAttributes: [CardProperty]
    
    let allTypes: [String]
    
    let kingdomTypes: [String]
    
    var allLandmarks: [Card] {
        self.allCards.filter({ $0.types.contains("Landmark") }).filter({!excludedCards.contains($0)})
    }
    
    var allEvents: [Card] {
        self.allCards.filter({ $0.types.contains("Event") }).filter({!excludedCards.contains($0)})
    }
    
    var allProjects: [Card] {
        self.allCards.filter({ $0.types.contains("Project") }).filter({!excludedCards.contains($0)})
    }
    
    var allWays: [Card] {
        self.allCards.filter({ $0.types.contains("Way") }).filter({!excludedCards.contains($0)})
    }
    
    // MARK: Maxes for creating picker inputs
    let maxPrice: Int
    let maxDebt: Int
    let maxActions: Int
    let maxBuys: Int
    let maxCards: Int
    let maxVictoryTokens: Int
    let maxCoinTokens: Int

    var cardsFromChosenExpansions: [Card] {
        get {
            let expansions = Settings.shared.chosenExpansions.count > 0 ? Settings.shared.chosenExpansions : self.allExpansions
            guard expansions.count > 0 else { return kingdomCards.filter { !excludedCards.contains($0) } }
            let cards = Utilities.deduplicateByName(cards:
                self.kingdomCards.filter { expansions.contains($0.expansion) && !excludedCards.contains($0) }
            )
            return cards
        }
    }
    
    private var bag = Set<AnyCancellable>()
    
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
        self.kingdomCards = self.allCards.filter { $0.supply }
        
        self.maxPrice = self.kingdomCards.map({$0.cost}).max(by: <) ?? 0
        self.maxDebt = self.kingdomCards.map({$0.debt}).max(by: <) ?? 0
        self.maxActions = self.kingdomCards.map({$0.actions}).max(by: <) ?? 0
        self.maxBuys = self.kingdomCards.map({$0.buys}).max(by: <) ?? 0
        self.maxCards = self.kingdomCards.map({$0.cards}).max(by: <) ?? 0
        self.maxVictoryTokens = self.kingdomCards.map({$0.tokens.victory}).max(by: <) ?? 0
        self.maxCoinTokens = self.kingdomCards.map({$0.tokens.coin}).max(by: <) ?? 0

        self.allExpansions = Array(Set(self.kingdomCards.map({$0.expansion}).filter { $0 != "" })).sorted()
        self.allAttributes = CardProperty.allCases
        self.kingdomTypes = self.kingdomCards.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            return Array(Set(allTypes).union(Set(types)))
        }).sorted()
        self.allTypes = self.allCards.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            return Array(Set(allTypes).union(Set(types)))
        }).sorted()
        
        excluded = excludedCards
        $excluded.sink { self.excludedCards = $0 }.store(in: &bag)
    }
}
