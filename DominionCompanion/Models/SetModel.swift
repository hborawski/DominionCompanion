//
//  SetModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct SetModel {
    // MARK: Specific Set Wide Effects
    var landmarks: [Card]
    var events: [Card]
    
    // MARK: Cards for this set
    var cards: [Card]
    var notInSupply: [Card]
    
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
            return self.cards.filter({$0.debt > 0}).count > 0
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
}
