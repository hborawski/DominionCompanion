//
//  GameplaySetup.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/18/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct GameplaySetup: View {
    @EnvironmentObject var cardData: CardData
    
    @AppStorage(Constants.SaveKeys.settingsGameplaySortMode) var sortMode: SortMode = .cost
    
    var model: SetModel
    
    @State var saveModal: Bool = false
    
    @State var saveText: String = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: SavedSet.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var sets: FetchedResults<SavedSet>
    
    @ViewBuilder
    var body: some View {
        List {
            Section(header: Text("In Supply")) {
                ForEach(model.cards.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                    CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                }
            }
            if model.notInSupply.count > 0 {
                Section(header: Text("Not In Supply")) {
                    ForEach(model.notInSupply.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if model.landmarks.count > 0 {
                Section(header: Text("Landmarks")) {
                    ForEach(model.landmarks.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if model.events.count > 0 {
                Section(header: Text("Events")) {
                    ForEach(model.events.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if model.projects.count > 0 {
                Section(header: Text("Projects")) {
                    ForEach(model.projects.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if model.ways.count > 0 {
                Section(header: Text("Ways")) {
                    ForEach(model.ways.sorted(by: sortMode.sortFunction()), id: \.name) { card in
                        CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                    }
                }
            }
            if model.getTokens().count > 0 {
                Section(header: Text("Tokens")) {
                    ForEach(model.getTokens(), id: \.self) { Text($0) }
                }
            }
            if model.getAdditionalMechanics().count > 0 {
                Section(header: Text("Additional Mechanics")) {
                    ForEach(model.getAdditionalMechanics(), id: \.self) { Text($0) }
                }
            }
            if model.shelters || model.colonies {
                Section(header: Text("Victory and Treasure")) {
                    if model.shelters {
                        Text("Shelters")
                    }
                    if model.colonies {
                        ForEach(cardData.allCards.filter({ ["Colony", "Platinum"].contains($0.name)}), id: \.name) { card in
                            CardRow(card: card) { Text(card.expansion) }.listRowInsets(EdgeInsets())
                        }
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .alert(isPresented: $saveModal, TextAlert(title: "Save Set", action: { saveName in
            guard let name = saveName else { return }
            let set = SavedSet(context: managedObjectContext)
            set.name = name
            set.date = Date()
            
            set.cards = model.cards.map({$0.name})
            set.events = model.events.map({$0.name})
            set.landmarks = model.landmarks.map({$0.name})
            set.projects = model.projects.map({$0.name})
            set.ways = model.ways.map({$0.name})
            
            let lastId = sets.sorted(by: { (set1, set2) -> Bool in
                set1.id < set2.id
                }).last?.id
            set.id = lastId.map {$0 + 1} ?? 1
            do {
                try managedObjectContext.save()
            } catch {
                Logger.shared.e("Error saving set")
            }
        }))
        .navigationTitle(Text("Gameplay Setup"))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                saveModal.toggle()
            }, label: {
                Text("Save")
            })
        })
    }
}

struct GameplaySetup_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        return GameplaySetup(
            model: SetModel(
                landmarks: [],
                events: [],
                projects: [],
                ways: [],
                cards: Array(cardData.cardsFromChosenExpansions.shuffled()[0...9])
            )
        ).environmentObject(cardData)
    }
}
