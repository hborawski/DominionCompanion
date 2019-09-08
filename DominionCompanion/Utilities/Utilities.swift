//
//  Utilities.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation

class Utilities {
    public static func shuffleArray<T>(_ array: [T]) -> [T] {
        return array.sorted { (l: T, r: T) -> Bool in
            return Int.random(in: 0...1) == 1
        }
    }
}
