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
    @IBOutlet weak var cardColorView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(_ card: Card, favorite: Bool = false) {
        self.pinnedLabel.text = favorite ? "pinned" : ""
        self.nameLabel.text = card.name
        self.costLabel.text = "\(card.cost)"
//        cardColorView.backgroundColor = card.colors.first
        makeColorView(card.colors)
//        makeTypeView(card.types)
    }
    
    func makeColorView(_ colors: [UIColor]) {
        guard colors.count > 0 else { return }
        guard let cardColorView = self.cardColorView else { return }
        cardColorView.arrangedSubviews.forEach{ subview in
            subview.removeFromSuperview()
        }
        let width = cardColorView.frame.width / CGFloat(colors.count)
        colors.forEach { color in
            addStripToView(color, view: cardColorView, width: width)
        }
        cardColorView.layoutIfNeeded()
    }
    
    func makeTypeView(_ types: [String]) {
        guard types.count > 0 else { return }
        guard let cardColorView = self.cardColorView else { return }
        cardColorView.arrangedSubviews.forEach{ subview in
            subview.removeFromSuperview()
        }
        let width = cardColorView.frame.width / CGFloat(types.count)
        types.forEach { type in
            let l = UILabel()
            l.text = type.first?.description
            cardColorView.addArrangedSubview(l)

            l.translatesAutoresizingMaskIntoConstraints = false

            l.heightAnchor.constraint(equalTo: cardColorView.heightAnchor).isActive = true
        }
        cardColorView.layoutIfNeeded()

    }
    
    func addStripToView(_ color: UIColor, view parentView: UIStackView, width: CGFloat) {
        let view = UIView()
        parentView.addArrangedSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.backgroundColor = color
    }
}
