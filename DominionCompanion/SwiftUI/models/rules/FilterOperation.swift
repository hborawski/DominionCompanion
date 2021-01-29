//
//  FilterOperation.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

enum FilterOperation: String, Codable {
    case greater = ">"
    case greaterOrEqual = "≥"
    case equal = "="
    case lessOrEqual = "≤"
    case less = "<"
    case notEqual = "≠"
}
