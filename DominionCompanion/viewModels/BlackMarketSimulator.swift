//
//  BlackMarketSimulator.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/18/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

class BlackMarketSimulator: ObservableObject {
    @Published var visibleCards: [Card] = []

    @Published var deck: [Card]

    @Published var discard: [Card] = []

    init(set: [Card], data: CardData) {
        let candidates = data.cardsFromChosenExpansions.filter({!set.contains($0)}).shuffled()
        let count = candidates.count >= Settings.shared.blackMarketDeckSize ? Settings.shared.blackMarketDeckSize : candidates.count
        deck = Array(candidates[0...(count - 1)])
    }

    func draw() {
        guard deck.count > 0 || discard.count > 0 else { return }
        if deck.count < 3, discard.count > 0 {
            deck = deck + (Settings.shared.blackMarketShuffle ? discard.shuffled() : discard)
            discard = []
        }
        let drawCount = deck.count >= 3 ? 3 : deck.count
        visibleCards = Array(deck[0...(drawCount - 1)])
        deck = Array(deck[drawCount...])
    }

    func pass() {
        discard = discard + visibleCards
        visibleCards = []
    }

    func buy(_ card: Card) {
        discard = discard + visibleCards.filter({ $0 != card })
        visibleCards = []
    }
}
