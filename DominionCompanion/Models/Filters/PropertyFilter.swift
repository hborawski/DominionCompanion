//
//  PropertyFilter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation


protocol PropertyFilter {
    static var availableOperations: [FilterOperation] { get }
    var property: CardProperty { get }
    var operation: FilterOperation { get }
    var stringValue: String { get }
    func match(_ card: Card) -> Bool
    init(property: CardProperty, value: String, operation: FilterOperation)
}
