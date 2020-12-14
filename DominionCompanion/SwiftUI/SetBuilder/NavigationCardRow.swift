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
        let pinned = setBuilder.pinnedCards.contains(card) || setBuilder.pinnedLandscape.contains(card)
//        let image = Image(systemName: pinned ? "xmark" : "checkmark")
//        let color = pinned ? Color.red : Color.blue
//        SwipableRow(
//            actions: [
//                (0, image, color, {setBuilder.pin(card)}),
//            ]
//        ) {
            NavigationLink(
                destination: CardView(card: card, accessory: pinButton).navigationBarTitleDisplayMode(.large),
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
                }
//        }
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
