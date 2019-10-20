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
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costBackground: UIView!
    @IBOutlet weak var cardColorView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(_ card: Card, favorite: Bool = false) {
        self.accessoryType = favorite ? .checkmark : .none
        self.nameLabel.text = card.name
        self.costLabel.text = "\(card.cost)"
        makeColorView(card.types)
        makeCostView()
    }
    
    func makeCostView() {
        guard let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
        let dimension = costLabel.frame.width
        let circleView = UIView()
        costBackground.insertSubview(circleView, at: 0)
        
        circleView.layer.cornerRadius = dimension / 2
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        circleView.centerXAnchor.constraint(equalTo: costLabel.centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
        circleView.backgroundColor = UIColor(named: "Treasure")
        costBackground.layoutIfNeeded()
        
    }
    
    func makeColorView(_ colors: [String]) {
        guard colors.count > 0 else { return }
        guard let cardColorView = self.cardColorView else { return }
        cardColorView.arrangedSubviews.forEach{ subview in
            subview.removeFromSuperview()
        }
        let width = cardColorView.frame.width / CGFloat(colors.count)
        colors.forEach { color in
            guard let uiColor = UIColor(named: color) else { return }
            addStripToView(uiColor, view: cardColorView, width: width)
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
