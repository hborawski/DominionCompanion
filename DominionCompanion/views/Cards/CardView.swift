//
//  CardView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct CardView<T>: View where T: View {
    @AppStorage(Constants.SaveKeys.settingsHideWikiLink) var hideWikiLink: Bool = false
    @EnvironmentObject var cardData: CardData
    @EnvironmentObject var setBuilder: SetBuilderModel
    var card: Card
    
    var accessory: ((Card) -> T) = { _ in EmptyView() as! T }
    
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
                            title: card.expansion,
                            accessory: self.accessory
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
                Image(uiImage: card.image ?? UIImage())
                    .resizable()
                    .cornerRadius(8)
                    .padding(.horizontal, 24)
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            relatedCards
        }
        .navigationTitle(Text(card.name))
        .navigationBarItems(trailing: self.accessory(self.card))
    }

    @ViewBuilder
    var relatedCards: some View {
        if card.relatedCards.count > 0 {
            VStack(alignment: .center) {
                NavigationLink(
                    destination: CardsView(
                        cards: card.relatedCards,
                        title: "Related Cards",
                        accessory: self.accessory
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
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let cardData = CardData()
        let c = cardData.allCards.filter { $0.name == "Vampire" }[0]
        return NavigationView {
            CardView<EmptyView>(card: c).environmentObject(cardData)
        }
    }
}
