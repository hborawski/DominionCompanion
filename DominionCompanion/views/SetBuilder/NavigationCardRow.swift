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
        let pinned = setBuilder.pinnedCards.contains(card) || setBuilder.pinnedLandscape.contains(card)
        NavigationLink(
            destination: CardView(card: card, accessory: { PinButton(card: $0) }).navigationBarTitleDisplayMode(.large),
            label: {
                CardRow(card: card) {
                    HStack {
                        if self.showExpansion {
                            Text(card.expansion).foregroundColor(.gray)
                        }
                        if setBuilder.pinnedCards.contains(card) || setBuilder.pinnedLandscape.contains(card) {
                            Image(systemName: "checkmark").foregroundColor(.blue).padding(.trailing, 0)
                        }
                    }
                }
            })
            .background(Color(.secondarySystemGroupedBackground))
            .buttonStyle(PlainButtonStyle())
            .contextMenu {
                Button(action: {
                    setBuilder.pin(card)
                }, label: {
                    pinned ?
                        HStack {
                            Image(systemName: "xmark")
                            Text("Unpin")
                        } :
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Pin")
                        }
                })
                Button(action: { setBuilder.pinnedCards = []}, label: {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Unpin All")
                    }
                })
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 1, trailing: 8))
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
