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
    var card: Card?

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costBackground: UIView!
    @IBOutlet weak var cardColorView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expansionLabel: UILabel!
    
    @IBOutlet weak var debtLabel: UILabel!
    @IBOutlet weak var debtBackground: UIView!
    
    func setData(_ card: Card, favorite: Bool = false, showExpansion: Bool = false) {
        self.card = card
        self.accessoryType = favorite ? .checkmark : .none
        self.nameLabel.text = card.name
        makeColorView(card.types)
        if card.debt > 0 {
            debtLabel.text = "\(card.debt)"
            makeDebtView()
            debtBackground.isHidden = false
            costBackground.isHidden = true
        } else if card.cost >= 0 {
            costLabel.text = "\(card.cost)"
            makeCostView()
            debtBackground.isHidden = true
            costBackground.isHidden = false
        } else {
            debtBackground.isHidden = true
            costBackground.isHidden = true
            costLabel.text = ""
            debtLabel.text = ""
        }
        
        if showExpansion {
            expansionLabel.isHidden = false
            expansionLabel.text = card.expansion
        } else {
            expansionLabel.isHidden = true
        }
    }
    
    func makeDebtView() {
        guard
            let debtBackground = self.debtBackground,
            let debtLabel = self.debtLabel else { return }

        let dimension = debtLabel.frame.width
        let segmentLength = dimension / 2
        let short = cos(CGFloat(Double.pi/3)) * segmentLength // the short distance horizontally
        let tall = sin(CGFloat(Double.pi/3)) * segmentLength // the distance between the midpoint and the top/bottom lines
        let buffer = (dimension - (tall * 2)) / 2 // since this wont fill a square view, there is a buffer between the top of the view and the top line
        let hexPath = UIBezierPath()
        hexPath.move(to: CGPoint(x: short, y: buffer))
        hexPath.addLine(to: CGPoint(x: short + segmentLength, y: buffer))        // -
        hexPath.addLine(to: CGPoint(x: dimension, y: buffer + tall))                 // \
        hexPath.addLine(to: CGPoint(x: segmentLength + short, y: buffer + tall*2))   // /
        hexPath.addLine(to: CGPoint(x: short, y: buffer + tall*2))                   // _
        hexPath.addLine(to: CGPoint(x: 0, y: buffer + tall))                         // \
        hexPath.addLine(to: CGPoint(x: short, y: buffer))                        // /
        let layer = CAShapeLayer()
        layer.fillColor = UIColor(named: "Debt")?.cgColor
        layer.path = hexPath.cgPath
        debtBackground.layer.insertSublayer(layer, at: 0)
        debtBackground.layoutIfNeeded()
    }
    
    func makeCostView() {
        guard
            costBackground.subviews.count == 1,
            let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
        let dimension = costLabel.frame.width
        let circleView = UIView()
        circleView.tag = 2000
        costBackground.insertSubview(circleView, at: 0)

        circleView.layer.cornerRadius = dimension / 2
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.heightAnchor.constraint(equalToConstant: dimension),
            circleView.widthAnchor.constraint(equalToConstant: dimension),
            circleView.centerXAnchor.constraint(equalTo: costLabel.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor)
        ])
        circleView.backgroundColor = UIColor(named: "Treasure")
        costBackground.layoutIfNeeded()
        
    }
    
    func makeColorView(_ colors: [String]) {
        guard colors.count > 0 else { return }
        guard let cardColorView = self.cardColorView else { return }
        cardColorView.arrangedSubviews.forEach{ subview in
            subview.removeFromSuperview()
        }

        colors.forEach { color in
            guard let uiColor = UIColor(named: color) else { return }
            addStripToView(uiColor, view: cardColorView)
        }
        cardColorView.layoutIfNeeded()
    }
    
    func addStripToView(_ color: UIColor, view parentView: UIStackView) {
        let view = UIView()
        parentView.addArrangedSubview(view)
        view.backgroundColor = color
    }
}
