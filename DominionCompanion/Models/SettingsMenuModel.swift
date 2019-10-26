//
//  SettingsMenuModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

struct MenuSection {
    var title: String
    var items: [MenuItem]
}

struct MenuItem {
    var title: String
    var destinationType: SettingsDestination
    var destination: String = ""
    var saveKey: String = ""
    var values: [String] = []
}

enum SettingsDestination {
    case viewController
    case toggle
    case list
}
