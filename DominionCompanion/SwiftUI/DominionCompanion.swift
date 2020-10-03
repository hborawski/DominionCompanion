//
//  DominionCompanion.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

@main
struct DominionCompanion: App {
    let cardData = CardData()
    var body: some Scene {
        WindowGroup {
            TabContainer()
                .environmentObject(cardData)
                .environmentObject(SetBuilderModel(cardData))
        }
    }
}
