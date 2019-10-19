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
    
    var allCards: [Card]
    
    let expansions: [String]
    
    let allAttributes: [CardProperty]
    
    let allTypes: [String]
    
    // MARK: Maxes for creating picker inputs
    let maxPrice: Int
    let maxActions: Int
    let maxBuys: Int
    let maxCards: Int
    
    var chosenExpansions: [Card] {
        get {
            let expansions = UserDefaults.standard.array(forKey: "expansions") as? [String] ?? self.expansions
            guard expansions.count > 0 else { return allCards }
            let cards = self.allCards.filter { expansions.contains($0.expansion) }
            return cards
        }
    }
    
    init() {
        do {
            if let path = Bundle.main.path(forResource: "cards", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDict = json as? Array<AnyObject> {
                    self.allCards = jsonDict.map({ Card($0 as! Dictionary<String, AnyObject>) }).sorted(by: Utilities.alphabeticSort(card1:card2:))
                } else {
                    self.allCards = []
                }
            } else {
                self.allCards = []
            }
        } catch {
            self.allCards = []
            print("Error")
        }
        let nonKingdom = ["Boon", "Curse", "Doom", "Event", "Hex", "Landmark", "Prize", "Ruins", "Shelter", "State"]
        self.allCards = self.allCards.filter { (card: Card) -> Bool in
            return Set(nonKingdom).intersection(Set(card.types)).count == 0
        }
        
        self.maxPrice = self.allCards.map({$0.cost}).max(by: {$0<$1}) ?? 0
        self.maxActions = self.allCards.map({$0.actions}).max(by: {$0<$1}) ?? 0
        self.maxBuys = self.allCards.map({$0.buys}).max(by: {$0<$1}) ?? 0
        self.maxCards = self.allCards.map({$0.cards}).max(by: {$0<$1}) ?? 0
        self.expansions = Array(Set(self.allCards.map({$0.expansion}).filter { $0 != "" })).sorted()
        
        self.allTypes = self.allCards.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            let fullSet = Set(allTypes)
            let newSet = Set(types)
            return Array(fullSet.union(newSet))
        }).sorted()
        
        self.allAttributes = CardProperty.allCases
        
    }
}