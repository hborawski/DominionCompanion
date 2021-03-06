//
//  DominionCompanion.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI
import CoreData

@main
struct DominionCompanion: App {
    let cardData = CardData()
    let toastModel = ToastModel()
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "SavedSets")
        container.loadPersistentStores { description, error in
            if let error = error {
                Logger.shared.e("Error loading coredata \(error)")
            }
        }
        return container
    }
    var body: some Scene {
        WindowGroup {
            TabContainer()
                .modifier(Toasted(toastModel))
                .environmentObject(cardData)
                .environmentObject(SetBuilderModel(cardData) { toastModel.show(message: $0, for: 2)})
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
                    let context = persistentContainer.viewContext
                    if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                Logger.shared.e("Error saving context")
                            }
                        }
                })
        }
    }
}
