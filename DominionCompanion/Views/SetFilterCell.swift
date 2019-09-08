//
//  SetFilterCell.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetFilterCell : UITableViewCell {
    @IBOutlet var cardCountLabel: UILabel!
    @IBOutlet var propertyLabel: UILabel!
    @IBOutlet var operationLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func setData(filter: SetFilter) {
        self.cardCountLabel.text = "\(filter.value)"
        self.propertyLabel.text = "\(filter.propertyFilter.property)"
        self.operationLabel.text = filter.propertyFilter.operation.rawValue
        self.valueLabel.text = filter.propertyFilter.stringValue
    }
}
