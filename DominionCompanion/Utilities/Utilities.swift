//
//  Utilities.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class Utilities {    
    public static func alphabeticSort(card1: Card, card2: Card) -> Bool {
        return card1.name <= card2.name
    }
    
    public static func priceSort(card1: Card, card2: Card) -> Bool {
        return card1.cost <= card2.cost
    }
}

