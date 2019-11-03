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
        if let layers = costBackground.layer.sublayers, layers.count > 1, let last = costBackground.layer.sublayers?.last {
            costBackground.layer.sublayers = [last]
        }
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
        guard let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
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
        guard let costBackground = self.costBackground,
            let costLabel = self.costLabel else { return }
        let dimension = costLabel.frame.width
        let layer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: dimension/2, y: dimension/2), radius: dimension/2, startAngle: 0, endAngle: 360, clockwise: true)
        layer.path = path.cgPath
        layer.fillColor = UIColor(named: "Treasure")?.cgColor
        costBackground.layer.insertSublayer(layer, at: 0)
//        let circleView = UIView()
//        costBackground.insertSubview(circleView, at: 0)
//
//        circleView.layer.cornerRadius = dimension / 2
//        circleView.translatesAutoresizingMaskIntoConstraints = false
//        circleView.heightAnchor.constraint(equalToConstant: dimension).isActive = true
//        circleView.widthAnchor.constraint(equalToConstant: dimension).isActive = true
//        circleView.centerXAnchor.constraint(equalTo: costLabel.centerXAnchor).isActive = true
//        circleView.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor).isActive = true
//        circleView.backgroundColor = UIColor(named: "Treasure")
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
