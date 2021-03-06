//
//  SettingsView.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Set Building Mechanics
    @AppStorage(Constants.SaveKeys.settingsColonies) var colonies: Bool = false
    
    @AppStorage(Constants.SaveKeys.settingsShelters) var shelters: Bool = false
    
    @AppStorage(Constants.SaveKeys.settingsMaxLandscape) var maxLandscape: Int = 0
    
    @AppStorage(Constants.SaveKeys.settingsAnyLandscape) var anyLandscape: Bool = false
    
    @AppStorage(Constants.SaveKeys.settingsNumLandmarks) var maxLandmarks: Int = 0
    @AppStorage(Constants.SaveKeys.settingsNumEvents) var maxEvents: Int = 0
    @AppStorage(Constants.SaveKeys.settingsNumProjects) var maxProjects: Int = 0
    @AppStorage(Constants.SaveKeys.settingsNumWays) var maxWays: Int = 0

    @AppStorage(Constants.SaveKeys.maxKingdomCards) var maxKingdomCards: Int = Settings.shared.maxKingdomCards
    
    // MARK: App Behavior
    @AppStorage(Constants.SaveKeys.settingsHideWikiLink) var hideWikiLinks: Bool = false
    @AppStorage(Constants.SaveKeys.settingsPinCards) var pinCardsForSetup: Bool = false
    @AppStorage(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
    @AppStorage(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansions: Bool = false
    @AppStorage(Constants.SaveKeys.settingsGameplaySortMode) var gameplaySortMode: SortMode = .cost

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Set Building Mechanics")) {
                    Toggle("Always use Colonies/Platinum", isOn: $colonies)
                    Toggle("Always use Shelters with Dark Ages", isOn: $shelters)
                    ListChoice(title: "Maximum Landscape Cards", value: "\(maxLandscape)", values: ["0", "1", "2"]) { val in
                        maxLandscape = Int(val) ?? 0
                    }
                    Toggle("Use Any Landscape Cards", isOn: $anyLandscape)
                    ListChoice(title: "Maximum Landmarks", value: "\(maxLandmarks)", values: ["0", "1", "2"]) { val in
                        maxLandmarks = Int(val) ?? 0
                    }
                    ListChoice(title: "Maximum Events", value: "\(maxEvents)", values: ["0", "1", "2"]) { val in
                        maxEvents = Int(val) ?? 0
                    }
                    ListChoice(title: "Maximum Projects", value: "\(maxProjects)", values: ["0", "1", "2"]) { val in
                        maxProjects = Int(val) ?? 0
                    }
                    ListChoice(title: "Maximum Ways", value: "\(maxWays)", values: ["0", "1", "2"]) { val in
                        maxWays = Int(val) ?? 0
                    }
                    ListChoice(title: "Maximum Kingdom Cards", value: "\(maxKingdomCards)", values: ["10", "11", "12", "13", "14", "15", "16"]) { val in
                        maxKingdomCards = Int(val) ?? 10
                    }
                }
                Section(header: Text("App Behavior")) {
                    Toggle("Hide Wiki Links", isOn: $hideWikiLinks)
                    Toggle("Pin all cards for setup", isOn: $pinCardsForSetup)
                    ListChoice(title: "Set Builder Sort Mode", value: sortMode.rawValue, values: SortMode.allCases.map{$0.rawValue}) { val in
                        if let mode = SortMode(rawValue: val) {
                            sortMode = mode
                        }
                    }
                    Toggle("Show Expansions in Set Builder", isOn: $showExpansions)
                    ListChoice(title: "Gameplay Setup Sort Mode", value: gameplaySortMode.rawValue, values: SortMode.allCases.map{$0.rawValue}) { val in
                        if let mode = SortMode(rawValue: val) {
                            gameplaySortMode = mode
                        }
                    }
                }
                Section(header: Text("Miscellaneous")) {
                    NavigationLink(destination: GlobalExclusions()) {
                        Text("Global Exclusions")
                    }
                }
                Section(header: Text("Legal")) {
                    NavigationLink(destination: Disclosures()) {
                        Text("Disclosures")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
