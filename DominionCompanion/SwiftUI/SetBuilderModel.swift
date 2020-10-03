//
//  SetBuilderModel.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/30/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import Combine

class SetBuilderModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    private let cardData: CardData
    @Published var currentSet: [Card] = []
    
    init(_ cardData: CardData) {
        self.cardData = cardData
    }
    
    func getSet() {
        Just(Array(cardData.cardsFromChosenExpansions.shuffled()[0..<10])).receive(on: RunLoop.main).assign(to: \.currentSet, on: self).store(in: &bag)
    }
}
