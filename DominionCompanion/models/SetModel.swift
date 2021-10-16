//
//  SetModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

struct SetModel {
    // MARK: Utility
    var expansions: [String] { Array(Set(self.cards.map { $0.expansion })).sorted(by: <)}
    var expansionString: String { self.expansions.joined(separator: " ") }
    // MARK: Specific Set Wide Effects
    var landmarks: [Card]
    var events: [Card]
    var projects: [Card]
    var ways: [Card]
    
    // MARK: Cards for this set
    var cards: [Card]
    var notInSupply: [Card] {
        get {
            return self.cards.map({$0.relatedCards}).reduce([]) { (relatedCards, nextRelated) -> [Card] in
                let next = nextRelated.filter({Set($0.types).intersection(Set(Constants.notGameplayRelatedTypes)).count == 0})
                let cardSet = Set(relatedCards + next)
                return Array(cardSet)
            }.filter { Set(["Knight", "Castle"]).intersection(Set($0.types)).count == 0 } // Knights and Castles are special and technically in the supply
        }
    }

    var allCards: [Card] {
        cards + notInSupply + landmarks + events + projects + ways
    }
    
    // MARK: General Required Extras
    var colonies: Bool {
        guard !Settings.shared.colonies else { return true }
        let chance = cards.filter({$0.expansion == "Prosperity"}).count
        guard chance > 0 else { return false }
        return chance >= Int.random(in: 0...Settings.shared.maxKingdomCards)
    }
    var shelters: Bool {
        let chance = cards.filter({$0.expansion == "Dark Ages"}).count
        guard chance > 0 else { return false }
        guard !Settings.shared.shelters else { return true }
        return chance >= Int.random(in: 0...Settings.shared.maxKingdomCards)
    }
    var boons: Bool { allCards.filter({$0.types.contains("Fate")}).count > 0 }
    var hexes: Bool { allCards.filter({$0.types.contains("Doom")}).count > 0 }
    var ruins: Bool { allCards.filter({$0.types.contains("Looter")}).count > 0 }
    var potions: Bool { allCards.filter({$0.potion}).count > 0 }
    var exile: Bool { allCards.filter({$0.exile}).count > 0 }
    var tavernMat: Bool { allCards.filter({$0.tavernMat}).count > 0 }
    var debt: Bool { allCards.filter({$0.tokens.debt}).count > 0 }
    var victoryTokens: Bool { allCards.filter({$0.tokens.victory > 0}).count > 0 }
    var coinTokens: Bool { allCards.filter({$0.tokens.coin > 0}).count > 0 }
    var embargoTokens: Bool { allCards.filter({$0.tokens.embargo}).count > 0 }
    var journeyToken: Bool { allCards.filter({$0.tokens.journey}).count > 0 }
    var minusCardTokens: Bool { allCards.filter({$0.tokens.minusCard}).count > 0 }
    var minusCoinTokens: Bool { allCards.filter({$0.tokens.embargo}).count > 0 }
    var plusCardTokens: Bool { allCards.filter({$0.tokens.plusCard}).count > 0 }
    var plusActionTokens: Bool { allCards.filter({$0.tokens.plusAction}).count > 0 }
    var plusBuyTokens: Bool { allCards.filter({$0.tokens.plusBuy}).count > 0 }
    var plusCoinTokens: Bool { allCards.filter({$0.tokens.plusCoin}).count > 0 }
    var minusCostTokens: Bool { allCards.filter({$0.tokens.minusCost}).count > 0 }
    var trashingTokens: Bool { allCards.filter({$0.tokens.trashing}).count > 0 }
    var estateTokens: Bool { allCards.filter({$0.tokens.estate}).count > 0 }
    var villagers: Bool { allCards.filter({$0.tokens.villagers}).count > 0}
    var projectTokens: Bool { projects.count > 0 }
    
    
    // MARK: Helpers
    func getTokens() -> [String] {
        var tokens: [String] = []
        
        if debt { tokens.append("Debt Tokens") }
        if victoryTokens { tokens.append("Victory Tokens") }
        if coinTokens { tokens.append("Coin Tokens") }
        if villagers { tokens.append("Coin Tokens (Villagers)") }
        if embargoTokens { tokens.append("Embargo Tokens") }
        if journeyToken { tokens.append("Journey Token") }
        if minusCardTokens { tokens.append("-Card Token") }
        if minusCoinTokens { tokens.append("-Coin Token") }
        if plusCardTokens { tokens.append("+Card Token") }
        if plusActionTokens { tokens.append("+Action Token") }
        if plusBuyTokens { tokens.append("+Buy Token") }
        if plusCoinTokens { tokens.append("+Coin Token") }
        if minusCostTokens { tokens.append("-Cost Token") }
        if trashingTokens { tokens.append("Trashing Token") }
        if estateTokens { tokens.append("Estate Token") }
        if projectTokens { tokens.append("Wooden Project Cubes") }
        return tokens
    }
    
    func getAdditionalMechanics() -> [String] {
        var mechanics: [String] = []
        
        if boons {
            mechanics.append("Boons")
        }
        
        if hexes {
            mechanics.append("Hexes")
        }
        
        if ruins {
            mechanics.append("Ruins")
        }

        if exile {
            mechanics.append("Exile Mat")
        }

        if tavernMat {
            mechanics.append("Tavern Mat")
        }

        if allCards.first(where: {$0.name == "Island"}) != nil {
            mechanics.append("Island Mat")
        }

        if allCards.first(where: {$0.name == "Native Village"}) != nil {
            mechanics.append("Native Village Mat")
        }

        if allCards.first(where: {$0.name == "Pirate Ship"}) != nil {
            mechanics.append("Pirate Ship Mat")
        }

        return mechanics
    }
    
    func getShareable() -> ShareableSet {
        return ShareableSet(
            cards: self.cards.map({$0.name}),
            events: self.events.map({$0.name}),
            landmarks: self.landmarks.map({$0.name}),
            projects: self.projects.map({$0.name}),
            ways: self.ways.map({$0.name})
        )
    }
}

// MARK: Sharing
struct ShareableSet: Codable {
    let cards: [String]
    let events: [String]
    let landmarks: [String]
    let projects: [String]
    let ways: [String]
    
    var name: String?
}

extension ShareableSet: Hashable {}

extension ShareableSet {
    func getSetModel() -> SetModel {
        let cards = self.cards.compactMap { (name) -> Card? in
            return CardData.shared.kingdomCards.first(where: {$0.name == name})
        }
        
        let events = self.events.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let landmarks = self.landmarks.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let projects = self.projects.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let ways = self.ways.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        return SetModel(landmarks: landmarks, events: events, projects: projects, ways: ways, cards: cards)
    }
}

struct GameplaySection {
    let title: String
    let rows: [UITableViewCell]
}
