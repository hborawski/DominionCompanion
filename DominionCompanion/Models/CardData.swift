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
    
    var cardData: [Card]
    
    let maxPrice: Int
    
    let expansions: [String]
    
    let allAttributes: [CardProperty]
    
    let allTypes: [String]
    
    init() {
        do {
            if let path = Bundle.main.path(forResource: "cards", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDict = json as? Array<AnyObject> {
                    self.cardData = jsonDict.map({ Card($0 as! Dictionary<String, AnyObject>) }).sorted(by: Utilities.alphabeticSort(card1:card2:))
                } else {
                    self.cardData = []
                }
            } else {
                self.cardData = []
            }
        } catch {
            self.cardData = []
            print("Error")
        }
        let nonKingdom = ["Boon", "Curse", "Doom", "Event", "Hex", "Landmark", "Prize", "Ruins", "Shelter"]
        self.cardData = self.cardData.filter { (card: Card) -> Bool in
            return Set(nonKingdom).intersection(Set(card.types)).count == 0
        }
        
        self.maxPrice = self.cardData.map({$0.cost}).max(by: {$0<$1}) ?? 0
        self.expansions = Array(Set(self.cardData.map({$0.expansion}).filter { $0 != "" })).sorted()
        
        self.allTypes = self.cardData.map({$0.types}).reduce([], { (types: [String], allTypes: [String]) -> [String] in
            let fullSet = Set(allTypes)
            let newSet = Set(types)
            return Array(fullSet.union(newSet))
        }).sorted()
        
        self.allAttributes = CardProperty.allCases
        
    }
}
