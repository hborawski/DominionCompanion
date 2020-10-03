//
//  CardView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @AppStorage(Constants.SaveKeys.settingsHideWikiLink) var hideWikiLink: Bool = false
    @EnvironmentObject var cardData: CardData
    var card: Card
    var link: URL? {
        guard
            let path = card.name.replacingOccurrences(of: " ", with: "_").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "http://wiki.dominionstrategy.com/index.php/\(path)") else {
            return nil
        }
        return url
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(
                        destination: CardsView(
                            cards: cardData.allCards.filter { $0.expansion == card.expansion },
                            title: card.expansion
                        )
                    ) {
                        HStack {
                            Image(systemName: "cube.box")
                            Text(card.expansion)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    Spacer()
                    if let url = link, !hideWikiLink {
                        HStack {
                            Image(systemName: "globe").foregroundColor(.blue)
                            Link("Wiki", destination: url)
                        }
                        .padding(.trailing, 24)
                    }
                }
                .padding(.vertical, 8)
                .padding(.leading, 24)
                Spacer()
                Image(uiImage: card.image() ?? UIImage())
                    .resizable()
                    .cornerRadius(8)
                    .padding(.horizontal, 24)
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            if card.relatedCards.count > 0 {
                VStack(alignment: .center) {
                    NavigationLink(
                        destination: CardsView(
                            cards: card.relatedCards,
                            title: "Related Cards"
                        )
                    ) {
                        HStack {
                            Image("Card")
                            Text("Related Cards")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)
                }
                .padding(0)
            }
        }
        .navigationTitle(Text(card.name))
    }
}

struct CardView_Previews: PreviewProvider {
    static let tokens = Tokens(victory: 0, coin: 0, embargo: false, debt: false, journey: false, minusCard: false, minusCoin: false, plusCard: false, plusAction: false, plusBuy: false, plusCoin: false, minusCost: false, trashing: false, estate: false, villagers: false)
    static let card = Card(cost: 2, debt: 0, potion: false, actions: 1, buys: 0, cards: 0, name: "Village", text: "", expansion: "Base", types: ["Action"], trash: false, exile: false, tokens: tokens, supply: true, related: [])
    static var previews: some View {
        NavigationView {
            CardView(card: card)
        }
    }
}
