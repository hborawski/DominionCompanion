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
            
            var defaults = [
                CardSection(title: "Set", cards: cards, pinnedCards: pinnedCards),
                CardSection(title: "All Cards", cards: cardPool, pinnedCards: pinnedCards, canShuffle: false)
            ]
            
            if maxEvents > 0 {
                let displayed = Array((pinnedEvents + randomEvents.filter { !pinnedEvents.contains($0) } )[0...(maxEvents - 1)])
                defaults.insert(CardSection(title: "Events", cards: displayed, pinnedCards: pinnedEvents), at: 0)
            }
            
            if maxLandmarks > 0 {
                let displayed = Array((pinnedLandmarks + randomLandmarks.filter { !pinnedLandmarks.contains($0) } )[0...(maxLandmarks - 1)])
                defaults.insert(CardSection(title: "Landmarks", cards: displayed, pinnedCards: pinnedLandmarks), at: 0)
            }
            
            return defaults
        }
    }
    
    var maxCards = 10
    
    var cardPool: [Card] {
        get {
            return FilterEngine.shared.matchAnyFilter.sorted(by: Utilities.alphabeticSort(card1:card2:))
        }
    }
    
    var maxLandmarks: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumLandmarks)
        }
    }
    
    var randomLandmarks: [Card] = []
    
    var pinnedLandmarks: [Card] {
        get {
            return self.loadPinned(Constants.SaveKeys.pinnedLandmarks)
        }
        set {
            self.savePinned(newValue, key: Constants.SaveKeys.pinnedLandmarks)
        }
    }
    
    var maxEvents: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumEvents)
        }
    }
    
    var randomEvents: [Card] = []
    
    var pinnedEvents: [Card] {
        get {
            return self.loadPinned(Constants.SaveKeys.pinnedEvents)
        }
        set {
            self.savePinned(newValue, key: Constants.SaveKeys.pinnedEvents)
        }
    }
    
    var pinnedCards: [Card] {
        didSet {
            fullSet = getFullSet()
            self.savePinned(self.pinnedCards, key: Constants.SaveKeys.pinnedCards)
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
        self.pinnedCards = loadPinned(Constants.SaveKeys.pinnedCards)
    }
    
    func pinCard(_ card: Card) {
        if card.types.contains("Landmark") {
            pinLandmark(card)
            return
        }
        if card.types.contains("Event") {
            pinEvent(card)
            return
        }
        guard pinnedCards.count < maxCards else { return }
        guard !pinnedCards.contains(card) else { return }
        pinnedCards.append(card)
        if let index = randomCards.index(of: card) {
            randomCards.remove(at: index)
        }
    }
    
    func pinLandmark(_ card: Card) {
        guard !pinnedLandmarks.contains(card) else { return }
        pinnedLandmarks.append(card)
    }
    
    func unpinLandmark(_ card: Card) {
        guard
            pinnedLandmarks.contains(card),
            let index = pinnedLandmarks.firstIndex(of: card)
            else { return }
        pinnedLandmarks.remove(at: index)
    }
    
    func pinEvent(_ card: Card) {
        guard !pinnedEvents.contains(card) else { return }
        pinnedEvents.append(card)
    }
    
    func unpinEvent(_ card: Card) {
        guard
            pinnedEvents.contains(card),
            let index = pinnedEvents.firstIndex(of: card)
            else { return }
        pinnedEvents.remove(at: index)
    }
    
    func unpinCard(_ card: Card) {
        if card.types.contains("Landmark") {
            unpinLandmark(card)
            return
        }
        if card.types.contains("Event") {
            unpinEvent(card)
            return
        }
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
            self.randomLandmarks = CardData.shared.allLandmarks.shuffled()
            self.randomEvents = CardData.shared.allEvents.shuffled()
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
    
    private func loadPinned(_ key: String) -> [Card] {
        guard let rawData = UserDefaults.standard.data(forKey: key),
            let cards = try? PropertyListDecoder().decode([Card].self, from: rawData) else { return [] }
        return cards
    }
    
    private func savePinned(_ cards: [Card], key: String) {
        if let data = try? PropertyListEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}


protocol SetBuilderSection {
    var title: String { get }
    var rows: [SetBuilderCardRow] { get }
    var cards: [Card] { get }
    var canShuffle: Bool { get }
}

struct CardSection: SetBuilderSection {
    var title: String
    var rows: [SetBuilderCardRow] {
        get {
            return self.cards.map { c in
                let card = c
                let pinned = self.pinnedCards.contains(card)
                return SetBuilderCardRow(card: card, pinned: pinned, pinAction: {
                    print("Pinning \(card.name)")
                    pinned ? SetBuilder.shared.unpinCard(c): SetBuilder.shared.pinCard(c)
                })
            }
        }
    }
    var cards: [Card]
    var pinnedCards: [Card]
    var canShuffle: Bool = true
}

struct SetBuilderCardRow {
    var card: Card
    var pinned: Bool
    var pinAction: () -> Void
}
