//
//  RecommendedSetsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct RecommendedSetsView: View {
    var recommendedSets = RecommendedSets.shared.sets
    @Binding var searchText: String
    var body: some View {
        List {
            ForEach(recommendedSets.filter { set in
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
        }
    }
}

struct RecommendedSetsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedSetsView(searchText: .constant(""))
    }
}
