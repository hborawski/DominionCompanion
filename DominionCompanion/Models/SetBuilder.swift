//
//  SetBuilder.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/8/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class SetBuilder {
    public static var shared: SetBuilder = SetBuilder()
    var maxCards = 10
    var cardPool: [Card] = []
    var pinnedCards: [Card] = []
    var randomCards: [Card] = []
    
    var fullSet: [Card] {
        get {
            guard self.randomCards.count > 0 else { return [] }
            let openSlots = maxCards - self.pinnedCards.count
            guard openSlots > 0 else { return self.pinnedCards }
            let numberToPick = openSlots < self.randomCards.count ? openSlots : (self.randomCards.count - 1)
            return pinnedCards + Array(self.randomCards[0...numberToPick])
        }
    }
    
    
    init() {
        self.cardPool = FilterEngine.shared.matchAnyFilter.sorted(by: Utilities.alphabeticSort(card1:card2:))
    }
    
    func pinCard(_ card: Card) {
        guard self.pinnedCards.count < maxCards else { return }
        guard !self.pinnedCards.contains(card) else { return }
        self.pinnedCards.append(card)
        if let index = self.randomCards.index(of: card) {
            self.randomCards.remove(at: index)
        }
    }
    
    func unpinCard(_ card: Card) {
        guard self.pinnedCards.contains(card) else { return }
        guard let index = self.pinnedCards.index(of: card) else { return }
        self.pinnedCards.remove(at: index)
        self.randomCards.insert(card, at: 0)
    }
    
    func shuffleSet(_ completion: @escaping () -> ()) {
        FilterEngine.shared.getMatchingSet(self.pinnedCards) { cards in
            self.randomCards = cards.filter { !self.pinnedCards.contains($0) }
            completion()
        }
    }
}
