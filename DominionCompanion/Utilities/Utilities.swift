//
//  Utilities.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class Utilities {    
    public static func alphabeticSort(card1: Card, card2: Card) -> Bool {
        guard let name1 = card1.name, let name2 = card2.name else { return false }
        return name1 <= name2
    }

    public static func combos<T>(elements: ArraySlice<T>, k: Int) -> [[T]] {
        if k == 0 {
            return [[]]
        }
        
        guard let first = elements.first else {
            return []
        }
        
        let head = [first]
        let subcombos = combos(elements: elements, k: k - 1)
        var ret = subcombos.map { head + $0 }
        ret += combos(elements: elements.dropFirst(), k: k)
        
        return ret
    }
    
    public static func combos<T>(elements: Array<T>, k: Int) -> [[T]] {
        return combos(elements: ArraySlice(elements), k: k)
    }
}
