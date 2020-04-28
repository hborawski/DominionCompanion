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
    
    @UserDefaultsBacked(Constants.SaveKeys.chosenExpansions) var chosenExpansions: [String] = []
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsColonies) var colonies: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsShelters) var shelters: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsAnyLandscape) var useAnyLandscape: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsPinCards) var pincardsForSetup: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsHideWikiLink) var hideWikiLink: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsShowExpansionsWhenBuilding) var showExpansionsWhenBuilding: Bool = false
    
    @UserDefaultsBackedEnum(Constants.SaveKeys.settingsSortMode) var sortMode: SortMode = .cost
    
    @UserDefaultsBackedEnum(Constants.SaveKeys.settingsGameplaySortMode) var gameplaySortMode: SortMode = .expansion
}


@propertyWrapper
struct UserDefaultsBacked<Value> {
    var value: Value
    let key: String
    
    var wrappedValue: Value {
        get { (UserDefaults.standard.object(forKey: key) as? Value) ?? value }
        set { UserDefaults.standard.set(newValue, forKey: key) }
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
struct UserDefaultsBackedCodable<Value> where Value: Codable {
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
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
    
    init(wrappedValue value: Value, _ key: String) {
        self.value = value
        self.key = key
    }
}
