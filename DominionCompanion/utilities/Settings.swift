//
//  Settings.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 4/12/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation

class Settings {
    static let shared = Settings()
    
    @UserDefaultsBacked(Constants.SaveKeys.maxKingdomCards) var maxKingdomCards: Int = 10

    @UserDefaultsBacked(Constants.SaveKeys.maxExpansions) var maxExpansions: Int = 10
    
    @UserDefaultsBacked(Constants.SaveKeys.chosenExpansions) var chosenExpansions: [String] = []
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsColonies) var colonies: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsShelters) var shelters: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsAnyLandscape) var useAnyLandscape: Bool = false

    @UserDefaultsBacked(Constants.SaveKeys.settingsMaxLandscape) var maxLandscape: Int = 0

    @UserDefaultsBacked(Constants.SaveKeys.settingsNumEvents) var maxEvents: Int = 0

    @UserDefaultsBacked(Constants.SaveKeys.settingsNumLandmarks) var maxLandmarks: Int = 0

    @UserDefaultsBacked(Constants.SaveKeys.settingsNumProjects) var maxProjects: Int = 0
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsNumWays) var maxWays: Int = 0
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsPinCards) var pincardsForSetup: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsHideWikiLink) var hideWikiLink: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansionsWhenBuilding: Bool = false
    
    @UserDefaultsBackedEnum(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
    
    @UserDefaultsBackedEnum(Constants.SaveKeys.settingsGameplaySortMode) var gameplaySortMode: SortMode = .expansion

    // For restoring setbuilder state when opening/closing
    @UserDefaultsBackedCodable(Constants.SaveKeys.currentCards) var currentCards: [Card] = []

    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedCards) var pinnedCards: [Card] = []

    @UserDefaultsBackedCodable(Constants.SaveKeys.currentLandscape) var currentLandscape: [Card] = []

    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedLandscape) var pinnedLandscape: [Card] = []

    @UserDefaultsBackedCodable(Constants.SaveKeys.pinnedRules) var pinnedRules: [Rule] = []
}


@propertyWrapper
class UserDefaultsBacked<Value>: ObservableObject {
    var value: Value
    let key: String
    
    var wrappedValue: Value {
        get { (UserDefaults.standard.object(forKey: key) as? Value) ?? value }
        set {
            objectWillChange.send()
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(wrappedValue value: Value, _ key: String) {
        self.value = value
        self.key = key
    }
}

@propertyWrapper
struct UserDefaultsBackedEnum<Value> where Value: RawRepresentable {
    var value: Value
    let key: String
    
    var wrappedValue: Value {
        get {
            let rawValue = UserDefaults.standard.object(forKey: key) as? Value.RawValue
            return Value.init(rawValue: rawValue ?? value.rawValue) ?? value
        }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: key) }
    }
    
    init(wrappedValue value: Value, _ key: String) {
        self.value = value
        self.key = key
    }
}

@propertyWrapper
class UserDefaultsBackedCodable<Value>: ObservableObject where Value: Codable {
    var value: Value
    let key: String
    
    var wrappedValue: Value {
        get {
            guard
                let rawData = UserDefaults.standard.data(forKey: key),
                let savedValue = try? PropertyListDecoder().decode(Value.self, from: rawData)
            else { return value }
            return savedValue
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                objectWillChange.send()
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
    
    init(wrappedValue value: Value, _ key: String) {
        self.value = value
        self.key = key
    }
}
