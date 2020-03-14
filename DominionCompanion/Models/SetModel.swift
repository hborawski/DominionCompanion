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
    // MARK: Specific Set Wide Effects
    var landmarks: [Card]
    var events: [Card]
    
    // MARK: Cards for this set
    var cards: [Card]
    var notInSupply: [Card] {
        get {
            return self.cards.map({$0.relatedCards}).reduce([]) { (relatedCards, nextRelated) -> [Card] in
                let next = nextRelated.filter({Set($0.types).intersection(Set(Constants.notGameplayRelatedTypes)).count == 0})
                let cardSet = Set(relatedCards + next)
                return Array(cardSet)
            }
        }
    }
    
    // MARK: General Required Extras
    var colonies: Bool
    var boons: Bool {
        get {
            return self.cards.filter({$0.types.contains("Fate")}).count > 0
        }
    }
    var hexes: Bool {
           get {
               return self.cards.filter({$0.types.contains("Doom")}).count > 0
           }
       }
    var debt: Bool {
        get {
            return self.cards.filter({$0.tokens.debt == true}).count > 0
        }
    }
    var potions: Bool {
        get {
            return self.cards.filter({$0.potion == true}).count > 0
        }
    }
    var victoryTokens: Bool {
        get {
            return self.cards.filter({$0.tokens.victory > 0}).count > 0
        }
    }
    var coinTokens: Bool {
        get {
            return self.cards.filter({$0.tokens.coin > 0}).count > 0
        }
    }
    
    func getSections(tableView: UITableView) -> [GameplaySection] {
        let getAttributedCardCell = { (card: Card) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else {
                return UITableViewCell()
            }
            cell.setData(card, favorite: false, showExpansion: true)
            return cell
        }
        
        let getBasicCell = { (text: String) -> UITableViewCell in
            let cell = UITableViewCell()
            cell.textLabel?.text = text
            return cell
        }
        
        var sections = [
            GameplaySection(title: "In Supply", rows: self.cards.sorted(by: sortByExpansionAndCost(card1:card2:)).map(getAttributedCardCell))
        ]
        
        if notInSupply.count > 0 {
            sections.append(GameplaySection(title: "Not In Supply", rows: self.notInSupply.sorted(by: sortByExpansionAndCost(card1:card2:)).map(getAttributedCardCell)))
        }
        
        if landmarks.count > 0 {
            sections.append(GameplaySection(title: "Landmarks", rows: self.landmarks.map(getAttributedCardCell)))
        }

        if events.count > 0 {
            sections.append(GameplaySection(title: "Events", rows: self.events.map(getAttributedCardCell)))
        }
        
        let tokens = getTokens()
        if tokens.count > 0 {
            sections.append(GameplaySection(title: "Tokens", rows: tokens.map(getBasicCell)))
        }
        
        let additionalMechanics = getAdditionalMechanics()
        if additionalMechanics.count > 0 {
            sections.append(GameplaySection(title: "Additional Mechanics", rows: additionalMechanics.map(getBasicCell)))
        }
        
        return sections
    }
    
    func getTokens() -> [String] {
        var tokens: [String] = []
        
        if debt {
            tokens.append("Debt Tokens")
        }
        if victoryTokens {
            tokens.append("Victory Tokens")
        }
        if coinTokens {
            tokens.append("Coin Tokens")
        }
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
        
        if potions {
            mechanics.append("Potion")
        }
        
        return mechanics
    }
    
    func sortByExpansionAndCost(card1: Card, card2: Card) -> Bool {
        return card1.expansion == card2.expansion ? (card1.cost < card2.cost) : (card1.expansion < card2.expansion)
    }
}

struct GameplaySection {
    let title: String
    let rows: [UITableViewCell]
}
