//
//  SavedRuleSet+CoreDataProperties.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 12/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedRuleSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRuleSet> {
        return NSFetchRequest<SavedRuleSet>(entityName: "SavedRuleSet")
    }

    @NSManaged public var name: String
    @NSManaged public var encodedRules: [String]
    
    var rules: [Rule] {
        get {
            let decoder = JSONDecoder()
            return encodedRules.compactMap { stringRule in
                guard
                    let data = stringRule.data(using: .utf8),
                    let rule = try? decoder.decode(Rule.self, from: data)
                else { return nil }
                return rule
            }
        }
        set {
            do {
                let encoder = JSONEncoder()
                let rules: [String] = try newValue.map { rule in
                    let ruleData = try encoder.encode(rule)
                    let stringRule = String(data: ruleData, encoding: .utf8)
                    return stringRule!
                }
                encodedRules = rules
            } catch(let error) {
                Logger.shared.e("\(error)")
            }
        }
    }
    
    func saveRules() {
        do {
            try managedObjectContext?.save()
        } catch {
            Logger.shared.e("Error Saving Rule Set")
        }
    }

    func with(name: String, rules: [Rule]) -> SavedRuleSet {
        self.name = name
        self.rules = rules
        return self
    }
}

extension SavedRuleSet: RuleBuilder {
    func removeRule(_ indexSet: IndexSet) {
        self.rules.remove(atOffsets: indexSet)
    }

    func addRule(_ rule: Rule) {
        if let index = rules.firstIndex(where: {$0.id == rule.id}) {
            rules[index] = rule
        } else {
            rules.append(rule)
        }
    }
}

extension SavedRuleSet : Identifiable {

}
