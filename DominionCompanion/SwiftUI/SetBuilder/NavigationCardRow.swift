//
//  NavigationCardRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/18/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct NavigationCardRow: View {
    @EnvironmentObject var setBuilder: SetBuilderModel
    
    var card: Card
    
    var showExpansion = false
    @ViewBuilder
    var body: some View {
        let pinButton = { c in
            Button(action: {setBuilder.pin(c)}, label: {
                if setBuilder.pinnedCards.contains(c) || setBuilder.pinnedLandscape.contains(c) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                } else {
                    Image(systemName: "checkmark.circle").foregroundColor(.gray)
                }
            }).buttonStyle(PlainButtonStyle())
        }
        NavigationLink(
            destination: CardView(card: card, accessory: pinButton),
            label: {
                if self.showExpansion {
                    CardRow(card: card) {
                        HStack {
                            Text(card.expansion).foregroundColor(.gray)
                            pinButton(card)
                        }
                    }
                } else {
                    CardRow(card: card) { pinButton(card) }
                }
            })
            .buttonStyle(PlainButtonStyle())
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
}

struct NavigationCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        let model = SetBuilderModel(cardData)
        model.pinnedCards.append(cardData.allCards[1])
        return List {
            NavigationCardRow(card: cardData.allCards[0]).environmentObject(model)
            NavigationCardRow(card: cardData.allCards[1]).environmentObject(model)
        }
    }
}
