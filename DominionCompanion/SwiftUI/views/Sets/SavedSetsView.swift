//
//  SavedSetsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SavedSetsView: View {
    @Binding var searchText: String
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: SavedSet.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var sets: FetchedResults<SavedSet>
    @ViewBuilder
    var body: some View {
        List {
            ForEach(sets.filter { set in
                guard searchText != "" else { return true }
                let matchesExpansion = set.getSetModel().expansions.first { $0.lowercased().contains(searchText.lowercased()) } != nil
                return matchesExpansion || set.name.lowercased().contains(searchText.lowercased()) 
            }, id: \.self) { set in
                let model = set.getSetModel()
                NavigationLink(
                    destination: GameplaySetup(model: model),
                    label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(set.name)
                                Text(model.expansions.joined(separator: ", ")).foregroundColor(.gray)
                            }
                            Spacer()
                            Text(set.formattedDate)
                        }
                    })
            }.onDelete(perform: { indexSet in
                for index in indexSet {
                    managedObjectContext.delete(sets[index])
                }
                do {
                    try managedObjectContext.save()
                } catch {
                    Logger.shared.e("Error Deleting set")
                }
            })
        }
    }
}

struct SavedSetsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSetsView(searchText: .constant(""))
    }
}
