//
//  Constants.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct Constants {
    static let nonKingdomTypes = ["Boon", "Curse", "Event", "Hex", "Landmark", "Prize", "Ruins", "Shelter", "State"]
    struct SaveKeys {
        static let pinnedRules = "pinnedRules"
        static let savedRules = "savedRules"
        static let pinnedCards = "pinnedCards"
        static let pinnedLandmarks = "pinnedLandmarks"
        static let pinnedEvents = "pinnedEvents"
        static let settingsNumEvents = "settings_numberOfEvents"
        static let settingsNumLandmarks = "settings_numberOfLandmarks"
        static let settingsColonies = "settings_colonies"
        static let settingsSortMode = "settings_sortMode"
    }
}
