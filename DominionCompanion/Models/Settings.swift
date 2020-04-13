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
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsColonies) var colonies: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsPinCards) var pincardsForSetup: Bool = false
    
    @UserDefaultsBacked(Constants.SaveKeys.settingsSortMode) var sortMode: String = "cost"
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
