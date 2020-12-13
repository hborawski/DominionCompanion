//
//  SavedSetsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SavedSetsView: View {
    var savedSets: SavedSets = SavedSets.shared
    @Binding var searchText: String
    
    @ViewBuilder
    var body: some View {
        List {
            ForEach(savedSets.savedSets.filter { set in
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
                            Text(set.formattedDate)
                        }
                    })
            }.onDelete(perform: { indexSet in
                for index in indexSet {
                    savedSets.delete(savedSet: savedSets.savedSets[index])
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
