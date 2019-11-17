//
//  TestData.swift
//  DominionCompanionTests
//
//  Created by Harris Borawski on 11/17/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class TestData {
    static let noTokens = Tokens(victory: 0, coin: 0, embargo: false, debt: false, journey: false, minusCard: false, minusCoin: false, plusCard: false, plusAction: false, plusBuy: false, plusCoin: false, minusCost: false, trashing: false, estate: false)
    
    static let actionCard = Card(cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action"], trash: false, tokens: TestData.noTokens, supply: true, related: [])
    
    static let treasureCard = Card(cost: 3, debt: 0, potion: false, actions: 0, buys: 0, cards: 0, name: "Treasure", text: "Treasure Card", expansion: "Test", types: ["Treasure"], trash: false, tokens: TestData.noTokens, supply: true, related: [])
    
    static let cost2Card = Card(cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action"], trash: false, tokens: TestData.noTokens, supply: true, related: [])
    
    static let cost3Card = Card(cost: 3, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action"], trash: false, tokens: TestData.noTokens, supply: true, related: [])
    
    static let cost4Card = Card(cost: 4, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action"], trash: false, tokens: TestData.noTokens, supply: true, related: [])
    
    static let trashCard = Card(cost: 4, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action"], trash: true, tokens: TestData.noTokens, supply: true, related: [])
    
    static let actionDurationCard = Card(cost: 4, debt: 0, potion: false, actions: 1, buys: 0, cards: 1, name: "Action", text: "Action Card", expansion: "Test", types: ["Action", "Duration"], trash: true, tokens: TestData.noTokens, supply: true, related: [])
}
