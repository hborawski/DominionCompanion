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

class CombinationGenerator<T> where T: Equatable {
    
    private let data: [T]
    private let size: Int

    private var current: [Int]
    private var currentIndex = 0
    
    init(_ array: [T], size: Int) {
        self.data = array
        self.size = size
        self.current = Array(0..<size).map { $0 }
        self.currentIndex = size - 1
        
    }
    
    func next() -> [T]? {
        guard let combo = getNext() else { return nil }
        return combo.map { data[$0] }
    }
    
    private func getNext() -> [Int]? {
        if current[0] >= (data.count - size + 1) { return nil }
        
        while (currentIndex > 0 && current[currentIndex] == data.count - size + currentIndex) {
            currentIndex -= 1
        }
        let retVal = current
        current[currentIndex] += 1
        while (currentIndex < size - 1) {
            current[currentIndex + 1] = current[currentIndex] + 1
            currentIndex += 1
        }
        return retVal
    }
    
}
