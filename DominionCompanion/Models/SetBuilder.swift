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
    var cardPool: [Card] {
        get {
            return FilterEngine.shared.matchAnyFilter.sorted(by: Utilities.alphabeticSort(card1:card2:))
        }
    }
    var pinnedCards: [Card] {
        didSet { fullSet = getFullSet() }
    }
    var randomCards: [Card] {
        didSet {
            fullSet = getFullSet()
        }
    }
    
    var fullSet: [Card] = []
    
    
    init() {
        self.randomCards = []
        self.pinnedCards = []
    }
    
    func pinCard(_ card: Card) {
        guard pinnedCards.count < maxCards else { return }
        guard !pinnedCards.contains(card) else { return }
        pinnedCards.append(card)
        if let index = randomCards.index(of: card) {
            randomCards.remove(at: index)
        }
    }
    
    func unpinCard(_ card: Card) {
        guard pinnedCards.contains(card) else { return }
        guard let index = pinnedCards.index(of: card) else { return }
        pinnedCards.remove(at: index)
        randomCards.insert(card, at: 0)
        if randomCards.count > maxCards - pinnedCards.count {
            randomCards.remove(at: randomCards.count - 1)
        }
    }
    
    func shuffleSet(_ completion: @escaping () -> ()) {
        FilterEngine.shared.getMatchingSet(pinnedCards) { cards in
            self.randomCards = cards.filter { !self.pinnedCards.contains($0) }
            completion()
        }
    }
    
    // MARK: Private
    private func getFullSet() -> [Card] {
        guard randomCards.count > 0 else { return pinnedCards }
        let openSlots = maxCards - pinnedCards.count
        guard openSlots > 0 else { return pinnedCards }
        let numberToPick = openSlots < randomCards.count ? openSlots : (randomCards.count - 1)
        let randoms = Array(randomCards[0...numberToPick])
        return pinnedCards + randoms
    }
}
