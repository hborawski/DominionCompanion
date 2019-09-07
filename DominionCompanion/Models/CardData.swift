//
//  CardData.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class CardData {
    public static let shared: CardData = CardData()
    
    let cardData: [Card]
    
    init() {
        do {
            if let path = Bundle.main.path(forResource: "cards", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDict = json as? Array<AnyObject> {
                    self.cardData = jsonDict.map { Card($0 as! Dictionary<String, AnyObject>) }
                } else {
                    self.cardData = []
                }
            } else {
                self.cardData = []
            }
        } catch {
            self.cardData = []
            print("Error")
        }
    }
}
