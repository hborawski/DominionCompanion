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
    
    var body: some View {
        List {
            ForEach(cardData.excluded, id: \.name) { card in
                let pinButton = Button(action: {self.exclude(card)}, label: {
                    Image(systemName: cardData.excluded.contains(card) ? "xmark.circle.fill" : "xmark.circle").foregroundColor(.blue)
                }).buttonStyle(PlainButtonStyle())
                NavigationLink(
                    destination: CardView(card: card) { _ in pinButton }
                ) {
                    CardRow(card: card) { pinButton }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            }
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
                destination: CardsView(cards: cardData.allCards, title: "Exclude Card", accessory: { card in
                    Button(action: {self.exclude(card)}, label: {
                        Image(systemName: cardData.excluded.contains(card) ? "xmark.circle.fill" : "xmark.circle").foregroundColor(.blue)
                    }).buttonStyle(PlainButtonStyle())
                }, showOnRow: true),
                isActive: $newExclusion,
                label: {
                    EmptyView()
                })
        )
    }
}

struct GlobalExclusions_Previews: PreviewProvider {
    static var previews: some View {
        GlobalExclusions()
    }
}
