//
//  CardsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardsView<T>: View where T: View {
    @EnvironmentObject var setBuilder: SetBuilderModel

    var cards: [Card]
    
    var title: String?
    
    var accessory: (Card) -> T = { _ in EmptyView() as! T }
    
    var showOnRow: Bool = false
    
    @State var searchText: String = ""
    
    @ViewBuilder
    var body: some View {
        List {
            SearchBar(text: $searchText)
            ForEach(cards.filter { searchText != "" ? $0.name.lowercased().contains(searchText) : true }, id: \.name) { card in
                NavigationLink(
                    destination: CardView(card: card, accessory: self.accessory)
                ) {
                    if self.showOnRow {
                        CardRow(card: card) { self.accessory(card) }
                    } else {
                        CardRow(card: card) { EmptyView() }
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
            }
        }
        .navigationTitle(Text(title ?? "All Cards"))
    }
}

struct CardsView_Previews: PreviewProvider {
    static let tokens = Tokens(victory: 0, coin: 0, embargo: false, debt: false, journey: false, minusCard: false, minusCoin: false, plusCard: false, plusAction: false, plusBuy: false, plusCoin: false, minusCost: false, trashing: false, estate: false, villagers: false)
    static let card = Card(cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 0, name: "Example", text: "", expansion: "Base", types: ["Action", "Duration"], trash: false, exile: false, tokens: tokens, supply: true, related: [])
    static var previews: some View {
        NavigationView {
            CardsView<EmptyView>(cards: [card])
        }
    }
}
