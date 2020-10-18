//
//  GlobalExclusions.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/18/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct GlobalExclusions: View {
    @EnvironmentObject var cardData: CardData
    
    func exclude(_ card: Card) {
        if cardData.excluded.contains(card) {
            cardData.excluded = cardData.excluded.filter { $0 != card }
        } else {
            cardData.excluded.append(card)
        }
    }

    @State var newExclusion: Bool = false
    
    @ViewBuilder
    var body: some View {
        let pinButton = { card in
            Button(action: {self.exclude(card)}, label: {
                if cardData.excluded.contains(card) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                } else {
                    Image(systemName: "xmark.circle").foregroundColor(.gray)
                }
            }).buttonStyle(PlainButtonStyle())
        }
        List {
            ForEach(cardData.excluded, id: \.name) { card in
                NavigationLink(
                    destination: CardView(card: card, accessory: pinButton)
                ) {
                    CardRow(card: card) { EmptyView() }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            }.onDelete(perform: { indexSet in
                cardData.excluded.remove(atOffsets: indexSet)
            })
        }
        .navigationTitle(Text("Excluded Cards"))
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.newExclusion.toggle()
            }, label: {
                Image(systemName: "plus")
            })
        })
        .background(
            NavigationLink(
                destination: CardsView(cards: cardData.allCards, title: "Exclude Card", accessory: pinButton, showOnRow: true),
                isActive: $newExclusion,
                label: {
                    EmptyView()
                })
        )
    }
}

struct GlobalExclusions_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        cardData.excluded = Array(cardData.allCards[0...9])
        return GlobalExclusions().environmentObject(cardData)
    }
}
