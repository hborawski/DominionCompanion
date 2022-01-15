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
                CardsView(cards: cardData.allCards, title: nil, accessory: { PinButton(card: $0) }, showOnRow: false)
            }.tabItem {
                Image("Card")
                Text("Cards")
            }
            SetsView().tabItem {
                Image(systemName: "list.dash")
                Text("Sets")
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
        let cardData = CardData()
        let model = SetBuilderModel(cardData)
        return TabContainer().environmentObject(cardData).environmentObject(model)
    }
}
