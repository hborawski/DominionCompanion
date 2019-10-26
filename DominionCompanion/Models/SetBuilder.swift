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
    
    var currentSet: [SetBuilderSection] {
        get {
            let cards = getFullSet()
            return [
                SetBuilderSection(title: "Set", cards: cards),
                SetBuilderSection(title: "All Cards", cards: cardPool, canShuffle: false)
            ]
        }
    }
    
    var maxCards = 10
    
    var cardPool: [Card] {
        get {
            return FilterEngine.shared.matchAnyFilter.sorted(by: Utilities.alphabeticSort(card1:card2:))
        }
    }
    
    var pinnedCards: [Card] {
        didSet {
            fullSet = getFullSet()
            self.savePinnedCards()
        }
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
        self.pinnedCards = loadPinnedCards()
    }
    
    func pinCard(_ card: Card) {
        guard card.types.first(where: { Constants.nonKingdomTypes.contains($0)}) == nil else {
            return
        }
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
    
    private func loadPinnedCards() -> [Card] {
        guard let rawData = UserDefaults.standard.data(forKey: "pinnedCards"),
            let cards = try? PropertyListDecoder().decode([Card].self, from: rawData) else { return [] }
        return cards
    }
    
    private func savePinnedCards(_ cards: [Card]? = nil) {
        if let data = try? PropertyListEncoder().encode(cards ?? self.pinnedCards) {
            UserDefaults.standard.set(data, forKey: "pinnedCards")
        }
    }
}

struct SetBuilderSection {
    var title: String
    var rows: [SetBuilderCardRow] {
        get {
            return self.cards.map { c in
                let pinned = SetBuilder.shared.pinnedCards.contains(c)
                return SetBuilderCardRow(card: c, pinned: pinned, pinAction: {pinned ? SetBuilder.shared.unpinCard(c): SetBuilder.shared.pinCard(c)})
            }
        }
    }
    var cards: [Card]
    var canShuffle: Bool = true
}

struct SetBuilderCardRow {
    var card: Card
    var pinned: Bool
    var pinAction: () -> Void
}
