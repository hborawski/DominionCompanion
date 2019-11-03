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
        makeColorView(card.types)
        if card.debt > 0 {
            self.costLabel.text = "\(card.debt)"
            makeDebtView()
        } else {
            self.costLabel.text = "\(card.cost)"
            makeCostView()
        }
    }
    
    func makeDebtView() {
        guard
            let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
        
        if costBackground.subviews[0].tag == 2000 {
            costBackground.subviews[0].removeFromSuperview()
        }
        let dimension = costLabel.frame.width
        let hexPath = UIBezierPath()
        hexPath.move(to: CGPoint(x: dimension/4, y: 0))
        hexPath.addLine(to: CGPoint(x: 3*(dimension/4), y: 0))
        hexPath.addLine(to: CGPoint(x: dimension, y: dimension/2))
        hexPath.addLine(to: CGPoint(x: 3*(dimension/4), y: dimension))
        hexPath.addLine(to: CGPoint(x: dimension/4, y: dimension))
        hexPath.addLine(to: CGPoint(x: 0, y: dimension/2))
        hexPath.addLine(to: CGPoint(x: dimension/4, y: 0))
        let layer = CAShapeLayer()
        layer.fillColor = UIColor(named: "Debt")?.cgColor
        layer.path = hexPath.cgPath
        costBackground.layer.insertSublayer(layer, at: 0)
        costBackground.layoutIfNeeded()
    }
    
    func makeCostView() {
        guard
            costBackground.subviews.count == 1,
            let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
        if let layers = costBackground.layer.sublayers, layers.count > 1 {
            layers[0].removeFromSuperlayer()
        }
        let dimension = costLabel.frame.width
        let circleView = UIView()
        circleView.tag = 2000
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
