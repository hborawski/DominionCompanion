//
//  Card.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class Card {
    var cost: Int? = 0
    var name: String? = "Card"
    var text: String? = "Text"
    var types: [String]? = []
    init(_ cardData: Dictionary<String, AnyObject>) {
        if let name = cardData["name"] as? String,
            let cost = cardData["cost"] as? Int,
            let text = cardData["text"] as? String,
            let types = cardData["types"] as? [String]
        {
            self.cost = cost
            self.name = name
            self.text = text
            self.types = types
        }
    }
}
