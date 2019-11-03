//
//  GameplaySetupViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class GameplaySetupViewController: UIViewController {
    var setModel: SetModel?
    
    override func viewDidLoad() {
        let lab = CardData.shared.kingdomCards.first(where: {$0.name == "Laboratory"})!
        self.setModel = SetModel(landmarks: [], events: [], cards: [lab], notInSupply: [], colonies: false)
    }
}
