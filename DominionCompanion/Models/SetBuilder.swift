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
            
            if maxEvents > 0, randomEvents.count > 0 {
                defaults.insert(CardSection(title: "Events", cards: randomEvents, pinnedCards: pinnedEvents), at: 0)
            }
            
            if maxLandmarks > 0, randomLandmarks.count > 0 {
                defaults.insert(CardSection(title: "Landmarks", cards: randomLandmarks, pinnedCards: pinnedLandmarks), at: 0)
            }
            
            if maxProjects > 0, randomProjects.count > 0 {
                defaults.insert(CardSection(title: "Projects", cards: randomProjects, pinnedCards: pinnedProjects), at: 0)
            }
            
            if maxWays > 0, randomWays.count > 0 {
                defaults.insert(CardSection(title: "Ways", cards: randomWays, pinnedCards: pinnedWays), at: 0)
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
    
    var maxLandscape: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsMaxLandscape)
        }
    }
    
    var maxLandmarks: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumLandmarks)
        }
    }
    
    var randomLandmarks: [Card] = []
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedLandmarks)
    var pinnedLandmarks: [Card] = []
    
    var maxEvents: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumEvents)
        }
    }
    
    var randomEvents: [Card] = []
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedEvents)
    var pinnedEvents: [Card] = []
    
    var maxProjects: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumProjects)
        }
    }
    
    var randomProjects: [Card] = []
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedProjects)
    var pinnedProjects: [Card] = []
    
    var maxWays: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.SaveKeys.settingsNumWays)
        }
    }
    
    var randomWays: [Card] = []
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedWays)
    var pinnedWays: [Card] = []
    
    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedCards)
    var pinnedCards: [Card] = []
    
    var randomCards: [Card] = []
    
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
        self.randomWays = pinnedWays + CardData.shared.allWays.shuffled()
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
        case card.types.contains("Way"):
            pinWay(card)
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
    
    func pinWay(_ card: Card) {
        guard !pinnedWays.contains(card) else { return }
        pinnedWays.append(card)
    }
    
    func unpinWay(_ card: Card) {
        guard
            pinnedWays.contains(card),
            let index = pinnedWays.firstIndex(of: card)
            else { return }
        pinnedWays.remove(at: index)
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
        case card.types.contains("Way"):
            unpinWay(card)
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
                let landscapeCards = self.getLandscapeCards()
                self.randomLandmarks = landscapeCards.filter { $0.types.contains("Landmark") }
                self.randomEvents = landscapeCards.filter { $0.types.contains("Event") }
                self.randomProjects = landscapeCards.filter { $0.types.contains("Project") }
                self.randomWays = landscapeCards.filter { $0.types.contains("Way") }
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
    
    func getLandscapeCards() -> [Card] {
        guard maxLandscape > 0 else { return [] }
        let pool = (CardData.shared.allEvents + CardData.shared.allLandmarks + CardData.shared.allProjects + CardData.shared.allWays).shuffled()
        var landscapes: [Card] = pinnedEvents + pinnedLandmarks + pinnedProjects + pinnedWays
        for card in pool {
            let temp = landscapes + [card]
            if areLandscapesValid(temp) {
                landscapes.append(card)
            }
            if landscapes.count == maxLandscape { break }
        }
        return landscapes
    }
    
    func areLandscapesValid(_ landscapes: [Card]) -> Bool {
        guard
            (landscapes.filter { $0.types.contains("Event") }).count <= maxEvents,
            (landscapes.filter { $0.types.contains("Landmark") }).count <= maxLandmarks,
            (landscapes.filter { $0.types.contains("Project") }).count <= maxProjects,
            (landscapes.filter { $0.types.contains("Way") }).count <= maxWays
        else { return false }
        return true
    }
    
    // MARK: Final Set
    func getFinalSet() -> SetModel {
        return SetModel(
            landmarks: Array(randomLandmarks[..<maxLandmarks]),
            events: Array(randomEvents[..<maxEvents]),
            projects: Array(randomProjects[..<maxProjects]),
            ways: Array(randomWays[..<maxWays]),
            cards: getFullSet()
        )
    }
    
    // MARK: Private
    private func getFullSet() -> [Card] {
        let sortFn = Settings.shared.sortMode.sortFunction()
        guard randomCards.count > 0 else { return pinnedCards.sorted(by: sortFn) }
        let openSlots = maxCards - pinnedCards.count
        guard openSlots > 0 else { return pinnedCards.sorted(by: sortFn) }
        let numberToPick = (openSlots < randomCards.count ? openSlots : randomCards.count) - 1
        let randoms = Array(randomCards[0...numberToPick])
        return pinnedCards.sorted(by: sortFn) + randoms.sorted(by: sortFn)
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
