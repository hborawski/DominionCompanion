//
//  ExpansionSelection.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/3/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct ExpansionSelection: View {
    @EnvironmentObject var cardData: CardData
    
    @ObservedObject @UserDefaultsBacked(Constants.SaveKeys.chosenExpansions) var chosenExpansions: [String] = []
    
    @ViewBuilder
    var body: some View {
        List {
            ForEach(cardData.allExpansions, id: \.self) { expansion in
                HStack {
                    Text(expansion)
                    Spacer()
                    if chosenExpansions.contains(expansion) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                    } else {
                        Image(systemName: "checkmark.circle").foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 1, perform: {
                    if chosenExpansions.contains(expansion) {
                        chosenExpansions = chosenExpansions.filter { expansion != $0}
                    } else {
                        chosenExpansions.append(expansion)
                    }
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Expansions")
    }
}

struct ExpansionSelection_Previews: PreviewProvider {
    static var previews: some View {
        ExpansionSelection().environmentObject(CardData())
    }
}
