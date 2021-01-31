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

    @State var selectedExpansion = ""

    @State var viewExpansion = false
    
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
                .contextMenu {
                    Button(action: {
                        selectedExpansion = expansion
                        viewExpansion = true
                    }, label: {
                        Text("View Cards")
                    })
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Expansions")
        .background(
            NavigationLink(
                destination: CardsView(cards: cardData.allCards.filter { $0.expansion == selectedExpansion }, title: selectedExpansion) {_ in EmptyView()},
                isActive: $viewExpansion,
                label: {
                    EmptyView()
                })
        )
    }
}

struct ExpansionSelection_Previews: PreviewProvider {
    static var previews: some View {
        ExpansionSelection().environmentObject(CardData())
    }
}
