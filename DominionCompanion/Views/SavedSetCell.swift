//
//  SavedSetCell.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/11/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SavedSetCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var expansionLabel: UILabel!
    
    func configure(_ savedSet: SavedSet) {
        let model = savedSet.getSetModel()
        let date = savedSet.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        self.nameLabel.text = savedSet.name
        self.dateLabel.text = formatter.string(from: date)
        self.dateLabel.alpha = 0.5
        self.expansionLabel.text = model.expansions.joined(separator: ", ")
        self.expansionLabel.alpha = 0.7
    }
}
