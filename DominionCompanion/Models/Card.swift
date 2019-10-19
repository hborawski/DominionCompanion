//
//  Card.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class Card {
    var cost: Int = 0
    var actions: Int = 0
    var buys: Int = 0
    var cards: Int = 0
    var name: String = ""
    var text: String = ""
    var expansion: String = ""
    var types: [String] = []
    var colors: [UIColor] = []
    var trash: Bool = false
    init(_ cardData: Dictionary<String, AnyObject>) {
        if let name = cardData["name"] as? String,
            let cost = cardData["cost"] as? Int,
            let actions = cardData["actions"] as? Int,
            let buys = cardData["buys"] as? Int,
            let cards = cardData["cards"] as? Int,
            let text = cardData["text"] as? String,
            let expansion = cardData["expansion"] as? String,
            let types = cardData["types"] as? [String],
            let trash = cardData["trash"] as? Bool
        {
            self.cost = cost
            self.actions = actions
            self.buys = buys
            self.cards = cards
            self.name = name
            self.text = text
            self.expansion = expansion
            self.types = types
            self.trash = trash
        } else {
            print(cardData)
        }
        self.colors = self.types.map({(type: String) -> UIColor? in
            return UIColor(named: type)
        }).filter { $0 != nil } as! [UIColor]
    }
    public func getProperty(_ property: CardProperty) -> Any {
        switch property {
        case .cost:
            return self.cost
        case .actions:
            return self.actions
        case .buys:
            return self.buys
        case .cards:
            return self.cards
        case .expansion:
            return [self.expansion]
        case .type:
            return self.types
        case .trash:
            return self.trash
        }
    }
    
    public func image() -> UIImage? {
        do {
            if let path = Bundle.main.path(forResource: "cards/\(self.name)", ofType: "jpg") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return UIImage(data: data)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension Card: Hashable {
    // MARK: Hashable
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.cost)
    }
}