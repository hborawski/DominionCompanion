//
//  CardRow.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardRow<T>: View where T: View {
    var card: Card
    
    var accessory: () -> T
    
    var colors: [UIColor]
    
    init(card: Card, @ViewBuilder accessory: @escaping () -> T) {
        self.card = card
        self.accessory = accessory
        colors = card.types.compactMap { UIColor(named: $0) }
    }

    @ViewBuilder
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                ForEach(colors, id: \.self) { color in
                    Rectangle()
                        .frame(width: CGFloat(50) / CGFloat(colors.count))
                        .foregroundColor(Color(color))
                        .padding(0)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .frame(width: 50)
            .padding(0)
            if card.debt == 0, card.cost >= 0, !card.potion {
                CostView(value: card.cost)
            } else if card.debt > 0 {
                DebtView(value: card.debt)
            } else if card.potion {
                PotionView(value: card.cost).padding(0)
            } else {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 36)
            }
            Text(card.name)
            Spacer()
            self.accessory().padding(.trailing, 10)
        }
    }
}

struct CardRow_Previews: PreviewProvider {
    static let tokens = Tokens(victory: 0, coin: 0, embargo: false, debt: false, journey: false, minusCard: false, minusCoin: false, plusCard: false, plusAction: false, plusBuy: false, plusCoin: false, minusCost: false, trashing: false, estate: false, villagers: false)
    static let card = Card(id: "1", cost: -1, debt: 0, potion: false, actions: 1, buys: 0, cards: 0, name: "Example", text: "", expansion: "Base", types: ["Action"], trash: false, exile: false, tavernMat: false, tokens: tokens, supply: true, related: [])
    static let card2 = Card(id: "2", cost: 4, debt: 4, potion: false, actions: 1, buys: 0, cards: 0, name: "Example", text: "", expansion: "Base", types: ["Action"], trash: false, exile: false, tavernMat: false, tokens: tokens, supply: true, related: [])
    static var previews: some View {
        let cardData = CardData()
        let cards = Array(cardData.allCards.shuffled()[0...4]) + [card]
        return List {
            Section(header: Text("Unpinned")) {
                ForEach(cards, id: \.name) { card in
                    CardRow(card: card){EmptyView()}.listRowInsets(EdgeInsets())
                }
            }
            Section(header: Text("Pinned")) {
                ForEach(cards, id: \.name) { card in
                    CardRow(card: card) {
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }.listRowInsets(EdgeInsets())
                }
            }
        }.listStyle(GroupedListStyle())
    }
}
