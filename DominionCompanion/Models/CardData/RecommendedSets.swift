//
//  RecommendedSets.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation

class RecommendedSets {
    static let shared = RecommendedSets()
    
    var sets: [ShareableSet] = []
    init() {
        guard
            let path = Bundle.main.path(forResource: "recommended-sets", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let decodedData = try? JSONDecoder().decode([ShareableSet].self, from: data)
        else { return }

        sets = decodedData
    }
}
