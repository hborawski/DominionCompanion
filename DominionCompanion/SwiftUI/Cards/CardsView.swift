//
//  CardsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardsView: View {
    var cards: [Card]
    
    var title: String?
    
    @State var searchText: String = ""
    var body: some View {
        List {
            SearchBar(text: $searchText)
            ForEach(cards.filter { searchText != "" ? $0.name.lowercased().contains(searchText) : true }, id: \.name) { card in
                NavigationLink(destination: CardView(card: card)) {
                    CardRow(card: card) { EmptyView() }
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
            CardsView(cards: [card])
        }
    }
}
