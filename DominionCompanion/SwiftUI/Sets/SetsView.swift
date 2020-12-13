//
//  SetsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/12/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SetsView: View {
    var recommendedSets = RecommendedSets.shared
    
    @State var searchText: String = ""
    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)
                ForEach(recommendedSets.sets.filter { set in
                    guard searchText != "" else { return true }
                    let matchesExpansion = set.getSetModel().expansions.first { $0.lowercased().contains(searchText.lowercased()) } != nil
                    return matchesExpansion || set.name?.lowercased().contains(searchText.lowercased()) ?? false
                }, id: \.self) { set in
                    let model = set.getSetModel()
                    NavigationLink(
                        destination: GameplaySetup(model: model),
                        label: {
                            VStack(alignment: .leading) {
                                Text(set.name ?? "")
                                Text(model.expansions.joined(separator: ", ")).foregroundColor(.gray)
                            }
                        })
                }
            }.navigationTitle(Text("Recommended Sets"))
        }
    }
}

struct SetsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsView()
    }
}
