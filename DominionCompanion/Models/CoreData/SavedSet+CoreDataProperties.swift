//
//  SavedSet+CoreDataProperties.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/11/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSet> {
        return NSFetchRequest<SavedSet>(entityName: "SavedSet")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    
    @NSManaged public var cards: [String]
    @NSManaged public var events: [String]
    @NSManaged public var landmarks: [String]
    @NSManaged public var projects: [String]
    @NSManaged public var ways: [String]
    
    func getSetModel() -> SetModel {
        let cards = self.cards.compactMap { (name) -> Card? in
            return CardData.shared.kingdomCards.first(where: {$0.name == name})
        }
        
        let events = self.events.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let landmarks = self.landmarks.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let projects = self.projects.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        let ways = self.ways.compactMap { (name) -> Card? in
            return CardData.shared.allCards.first(where: {$0.name == name})
        }
        
        return SetModel(landmarks: landmarks, events: events, projects: projects, ways: ways, cards: cards)
    }
    
    var formattedDate: String {
        let date = self.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter.string(from: date)
    }
}
