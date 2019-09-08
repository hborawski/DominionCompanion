//
//  AttributedCardCell.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class AttributedCardCell : UITableViewCell {
    @IBOutlet weak var pinnedLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var cardColorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(_ card: Card, favorite: Bool = false) {
        self.pinnedLabel.text = favorite ? "pinned" : ""
        self.nameLabel.text = card.name
        if let cost = card.cost {
            self.costLabel.text = "\(cost)"
        }
    }
}
