//
//  CardFilter.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 3/14/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

class CardFilter: RuleBuilder, ObservableObject {
    @Published var rule: Rule
    var rules: [Rule] = []

    init() {
        rule = Rule(value: 0, operation: .greater, conditions: [])
    }

    func removeRule(_ indexSet: IndexSet) {}

    func addRule(_ rule: Rule) {
        self.rule = rule
    }

    func reset() {
        rule = Rule(value: 0, operation: .greater, conditions: [])
    }
}
