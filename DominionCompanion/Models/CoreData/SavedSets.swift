//
//  SavedSets.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/11/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import CoreData
class SavedSets {
    static var shared = SavedSets()
    
    var savedSets: [SavedSet] = []
    
    var container = NSPersistentContainer(name: "SavedSets")
    
    init() {
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("Error loading CoreData")
                return
            }
            print(String(describing: description))
        }
        reloadSavedSets()
    }
    
    //MARK: Public API
    
    func saveSet(name: String, model: SetModel) {
        let set = SavedSet(context: container.viewContext)
        set.name = name
        set.date = Date()
        
        set.cards = model.cards.map({$0.name})
        set.events = model.events.map({$0.name})
        set.landmarks = model.landmarks.map({$0.name})
        set.projects = model.projects.map({$0.name})
        set.ways = model.ways.map({$0.name})
        
        let lastId = savedSets.sorted(by: { (set1, set2) -> Bool in
            set1.id < set2.id
            }).last?.id
        set.id = lastId.map {$0 + 1} ?? 1
        
        saveContext()
        reloadSavedSets()
    }
    
    private func reloadSavedSets() {
        let request: NSFetchRequest<SavedSet> = SavedSet.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            savedSets = try container.viewContext.fetch(request)
        } catch {
            print("Loading saved sets failed")
        }
    }

    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
