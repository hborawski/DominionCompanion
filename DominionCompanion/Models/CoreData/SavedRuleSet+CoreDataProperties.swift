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
    @NSManaged public var rules: [String]
    
    var decodedRules: [SetRule] {
        let decoder = JSONDecoder()
        return rules.compactMap { stringRule in
            guard
                let data = stringRule.data(using: .utf8),
                let rule = try? decoder.decode(SetRule.self, from: data)
            else { return nil }
            return rule
        }
    }

}

extension SavedRuleSet : Identifiable {

}
