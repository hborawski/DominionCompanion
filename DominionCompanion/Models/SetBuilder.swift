//
//  SetBuilder.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/8/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
enum SetBuilderError: Error {
    case failedToBuild(reason: String)
}
class SetBuilder {
    public static var shared: SetBuilder = SetBuilder()
    
    var currentSet: [SetBuilderSection] {
        get {
            let cards = getFullSet()
            let sectionTitle = RuleEngine.shared.rules.count > 0 ? "Cards Matching Any Rules" : "All Cards"
            var defaults = [
                CardSection(title: "Set", cards: cards, pinnedCards: pinnedCards),
                CardSection(title: sectionTitle, cards: cardPool, pinnedCards: pinnedCards, canShuffle: false)
            ]
            
            if maxEvents > 0 {
                let displayed = Array((pinnedEvents + randomEvents.filter { !pinnedEvents.contains($0) } )[0...(maxEvents - 1)])
                defaults.insert(CardSection(title: "Events", cards: displayed, pinnedCards: pinnedEvents), at: 0)
            }
            
            if maxLandmarks > 0 {
                let displayed = Array((pinnedLandmarks + randomLandmarks.filter { !pinnedLandmarks.contains($0) } )[0...(maxLandmarks - 1)])
                defaults.insert(CardSection(title: "Landmarks", cards: displayed, pinnedCards: pinnedLandmarks), at: 0)
            }
            
            if maxProjects > 0 {
                let displayed = Array((pinnedProjects + randomProjects.filter { !pinnedProjects.contains($0) } )[0...(maxProjects - 1)])
                defaults.insert(CardSection(title: "Projects", cards: displayed, pinnedCards: pinnedProjects), at: 0)
            }
            
            return defaults
        }
    }
    
    var maxCards = 10
    
    var cardPool: [Card] {
        get {
            return RuleEngine.shared.matchAnyRule.sorted(by: Utilities.alphabeticSort(card1:card2:))
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
    
    var maxProjects: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumProjects)
        }
    }
    
    var randomProjects: [Card] = []
    
    var pinnedProjects: [Card] {
        get {
            return self.loadPinned(Constants.SaveKeys.pinnedProjects)
        }
        set {
            self.savePinned(newValue, key: Constants.SaveKeys.pinnedProjects)
        }
    }
    
    var pinnedCards: [Card] = [] {
        didSet {
            fullSet = getFullSet()
            self.savePinned(self.pinnedCards, key: Constants.SaveKeys.pinnedCards)
        }
    }
    
    var randomCards: [Card] = [] {
        didSet {
            fullSet = getFullSet()
        }
    }
    
    var fullSet: [Card] = []
    
    var setComplete: Bool {
        get {
            return (pinnedCards.count == maxCards) &&
                   (pinnedEvents.count >= maxEvents) &&
                   (pinnedLandmarks.count >= maxLandmarks) &&
                   (pinnedProjects.count >= maxProjects)
        }
    }
    
    
    init() {
        self.randomLandmarks = pinnedLandmarks + CardData.shared.allLandmarks.shuffled()
        self.randomEvents = pinnedEvents + CardData.shared.allEvents.shuffled()
        self.randomProjects = pinnedProjects + CardData.shared.allProjects.shuffled()
        self.pinnedCards = loadPinned(Constants.SaveKeys.pinnedCards)
        self.fullSet = getFullSet()
    }
    
    // MARK: Pinning
    func pin(_ card: Card) {
        switch true {
        case card.types.contains("Landmark"):
            pinLandmark(card)
        case card.types.contains("Event"):
            pinEvent(card)
        case card.types.contains("Project"):
            pinProject(card)
        default:
            pinCard(card)
        }
    }
    
    func pinCard(_ card: Card) {
        guard
            pinnedCards.count < maxCards,
            !pinnedCards.contains(card)
        else { return }
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
    
    func pinProject(_ card: Card) {
        guard !pinnedProjects.contains(card) else { return }
        pinnedProjects.append(card)
    }
    
    func unpinProject(_ card: Card) {
        guard
            pinnedProjects.contains(card),
            let index = pinnedProjects.firstIndex(of: card)
            else { return }
        pinnedProjects.remove(at: index)
    }
    
    func unpinCard(_ card: Card) {
        guard
            pinnedCards.contains(card),
            let index = pinnedCards.index(of: card)
        else { return }
        pinnedCards.remove(at: index)
        randomCards.insert(card, at: 0)
        if randomCards.count > maxCards - pinnedCards.count {
            randomCards.remove(at: randomCards.count - 1)
        }
    }
    
    func unpin(_ card: Card) {
        switch true {
        case card.types.contains("Landmark"):
            unpinLandmark(card)
        case card.types.contains("Event"):
            unpinEvent(card)
        case card.types.contains("Project"):
            unpinProject(card)
        default:
            unpinCard(card)
        }
    }
    
    // MARK: Set Shuffle
    func shuffleSet(_ completion: @escaping (Result<Bool, SetBuilderError>) -> ()) {
        RuleEngine.shared.getMatchingSet(pinnedCards) { result in
            switch result {
            case .success(let cards):
                self.randomCards = cards.filter { !self.pinnedCards.contains($0) }
                self.randomLandmarks = self.pinnedLandmarks + CardData.shared.allLandmarks.shuffled()
                self.randomEvents = self.pinnedEvents + CardData.shared.allEvents.shuffled()
                self.randomProjects = self.pinnedProjects + CardData.shared.allProjects.shuffled()
                completion(.success(true))
            case .failure(let error):
                switch error {
                case .notSatisfiable:
                    completion(.failure(.failedToBuild(reason: "One or more rules are not satisfiable from available cards.")))
                case .tooManyAttempts:
                    completion(.failure(.failedToBuild(reason: "Rules are individually valid but not satisfiable together.")))
                }
            }
        }
    }
    
    // MARK: Final Set
    func getFinalSet() -> SetModel {
        return SetModel(
            landmarks: Array(randomLandmarks[..<maxLandmarks]),
            events: Array(randomEvents[..<maxEvents]),
            projects: Array(randomProjects[..<maxProjects]),
            cards: getFullSet()
        )
    }
    
    // MARK: Private
    private func getFullSet() -> [Card] {
        guard randomCards.count > 0 else { return pinnedCards.sorted(by: getSortFunction()) }
        let openSlots = maxCards - pinnedCards.count
        guard openSlots > 0 else { return pinnedCards.sorted(by: getSortFunction()) }
        let numberToPick = (openSlots < randomCards.count ? openSlots : randomCards.count) - 1
        let randoms = Array(randomCards[0...numberToPick])
        return pinnedCards.sorted(by: getSortFunction()) + randoms.sorted(by: getSortFunction())
    }
    
    private func getSortFunction() -> ((Card, Card) -> Bool) {
        let sortMode = UserDefaults.standard.string(forKey: Constants.SaveKeys.settingsSortMode)
        switch sortMode {
        case "cost":
            return Utilities.priceSort(card1:card2:)
        default:
            return Utilities.alphabeticSort(card1:card2:)
            
        }
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
                    pinned ? SetBuilder.shared.unpin(c) : SetBuilder.shared.pin(c)
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
