//
//  RuleViewModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/18/21.
//  Copyright © 2021 Harris Borawski. All rights reserved.
//

import Foundation

class RuleViewModel: ObservableObject, RuleBuilder {

    @Published var precondition: Rule?

    @Published var rules: [Rule] = [] {
        didSet {
            precondition = rules.first
        }
    }

    func removeRule(_ indexSet: IndexSet) {
        self.rules.remove(atOffsets: indexSet)
    }

    func addRule(_ rule: Rule) {
        self.rules = [rule]
    }
}
