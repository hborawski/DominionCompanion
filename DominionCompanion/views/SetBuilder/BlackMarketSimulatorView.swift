//
//  BlackMarketSimulator.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/18/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import SwiftUI

struct BlackMarketSimulatorView: View {
    var cards: [Card] = []

    @ObservedObject var model: BlackMarketSimulator
    init(cards: [Card], data: CardData) {
        model = BlackMarketSimulator(set: cards, data: data)
    }
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack {
                    ForEach(model.visibleCards, id: \.id) { card in
                        HStack(alignment: .center) {
                            NavigationLink(
                                destination: CardView<EmptyView>(card: card)
                            ) {
                                if let image = card.image() {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geo.size.width / 3)
                                } else {
                                    Text(card.name)
                                }
                            }
                            VStack(alignment: .leading) {
                                HStack {
                                    CostView(value: card.cost)
                                    if card.debt > 0 {
                                        DebtView(value: card.debt)
                                    }
                                    Text(card.name)
                                }

                                Button(action: {
                                    model.buy(card)
                                }, label: {
                                    HStack {
                                        Image(systemName: "dollarsign.circle.fill")
                                        Text("Buy")
                                    }.foregroundColor(.white).padding(8).frame(maxWidth: .infinity)
                                }).background(RoundedRectangle(cornerRadius: 4).foregroundColor(.blue))
                            }
                            Spacer()
                        }.frame(maxWidth: .infinity)
                    }
                }
            }
            Spacer()
            HStack(spacing: 24) {
                NavigationLink(destination: CardsView<EmptyView>(cards: (model.deck + model.discard).sorted(by: Utilities.alphabeticSort(card1:card2:)))) {
                    HStack {
                        Image("Deck")
                        Text("\(model.deck.count + model.discard.count)")
                    }
                }
                Button(action: model.draw, label: {
                    HStack {
                        Image("Card")
                        Text("Reveal")
                    }
                }).disabled(!model.visibleCards.isEmpty)
                Button(action: model.pass, label: {
                    HStack {
                        Image(systemName: "arrow.turn.up.right")
                        Text("Pass")
                    }
                }).disabled(model.visibleCards.isEmpty)
            }.padding(8).frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity).navigationTitle("Black Market")
    }
}

struct BlackMarketSimulator_Previews: PreviewProvider {
    static var previews: some View {
        BlackMarketSimulatorView(cards: [], data: CardData.shared)
    }
}
