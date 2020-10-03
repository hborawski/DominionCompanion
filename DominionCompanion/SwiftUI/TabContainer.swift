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
    var body: some View {
        TabView {
            SetBuilderView().tabItem {
                Image("Deck")
                Text("Set Builder")
            }
            NavigationView {
                CardsView(cards: cardData.allCards)
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
