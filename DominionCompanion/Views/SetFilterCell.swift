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
    @IBOutlet var cardOperationLabel: UILabel!
    @IBOutlet var cardCountLabel: UILabel!    
    @IBOutlet weak var ruleStack: UIStackView!
    @IBOutlet weak var cardIcon: UIImageView!
    var rule: SetRule?
    func setData(rule: SetRule) {
        self.cardOperationLabel.text = rule.operation.rawValue
        self.cardCountLabel.text = "\(rule.value)"
        
        ruleStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rule.cardRules.forEach { rule in
            let label = UILabel()
            label.text = "\(rule.property.rawValue) \(rule.operation.rawValue) \(rule.comparisonValue)"
            ruleStack.addArrangedSubview(label)
        }
        setLabelColor()
    }
    
    func setLabelColor() {
        DispatchQueue.global(qos: .background).async {
            guard let rule = self.rule else { return }
            if !rule.satisfiable(RuleEngine.shared.cardData) {
                DispatchQueue.main.async {
                    self.cardCountLabel.textColor = .red
                }
            } else {
                DispatchQueue.main.async {
                    if #available(iOS 13, *) {
                        self.cardCountLabel.textColor = .label
                    } else {
                        self.cardCountLabel.textColor = .black
                    }
                }
            }
        }
    }
}
