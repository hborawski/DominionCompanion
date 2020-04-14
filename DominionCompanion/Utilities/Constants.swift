//
//  Constants.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

struct Constants {
    static let nonKingdomTypes = ["Artifact", "Boon", "Curse", "Event", "Heirloom", "Hex", "Landmark", "Prize", "Project", "Ruins", "Shelter", "State"]
    static let notGameplayRelatedTypes = ["Boon", "Hex", "Ruins"]
    struct SaveKeys {
        static let pinnedRules = "pinnedRules"
        static let savedRules = "savedRules"
        static let pinnedCards = "pinnedCards"
        static let pinnedLandmarks = "pinnedLandmarks"
        static let pinnedProjects = "pinnedProjects"
        static let pinnedEvents = "pinnedEvents"
        static let settingsNumEvents = "settings_numberOfEvents"
        static let settingsNumProjects = "settings_numberOfProjects"
        static let settingsNumLandmarks = "settings_numberOfLandmarks"
        static let settingsColonies = "settings_colonies"
        static let settingsSortMode = "settings_sortMode"
        static let settingsPinCards = "settings_pincards"
    }
}
