//
//  TabContainer.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct TabContainer: View {
    @EnvironmentObject var cardData: CardData
    @EnvironmentObject var setBuilder: SetBuilderModel

    var body: some View {
        TabView {
            SetBuilderView().tabItem {
                Image("Deck")
                Text("Set Builder")
            }
            NavigationView {
                CardsView(cards: cardData.allCards, title: nil, accessory: { card in
                    Button(action: {setBuilder.pin(card)}, label: {
                        Image(systemName: setBuilder.pinnedLandscape.contains(card) || setBuilder.pinnedCards.contains(card) ? "checkmark.circle.fill" : "checkmark.circle").foregroundColor(.blue)
                    }).buttonStyle(PlainButtonStyle())
                }, showOnRow: false)
            }.tabItem {
                Image("Card")
                Text("Cards")
            }
            SettingsView().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
    }
}

struct TabContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
