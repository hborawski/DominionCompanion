//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    var card: Card?
    var excludeMode: Bool = false
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var expansionLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let card = self.card else { return }
        
        setupPinButton()
        
        self.nameLabel.text = card.name
        self.expansionLabel.text = card.expansion
        self.textLabel?.text = card.text
        if let image = card.image() {
            self.imageView.image = image
        }
    }
    
    func setupPinButton() {
        let exclude = UIBarButtonItem(image: UIImage(named: "Exclude"), style: .plain, target: self, action: #selector(doExclude(_:)))
        let add = UIBarButtonItem(image: UIImage(named: "Checkmark"), style: .plain, target: self, action: #selector(doPin(_:)))
        let remove = UIBarButtonItem(image: UIImage(named: "Delete"), style: .plain, target: self, action: excludeMode ? #selector(doExclude(_:)) : #selector(doPin(_:)))
        guard let card = self.card else { return }
        if
            !excludeMode && SetBuilder.shared.pinnedCards.contains(card) ||
            excludeMode && CardData.shared.excludedCards.contains(card)
        {
            self.navigationItem.rightBarButtonItem = remove
            
        } else {
            self.navigationItem.rightBarButtonItem = excludeMode ? exclude : add
        }
    }
    
    @objc func doPin(_ sender: UIBarButtonItem) {
        guard let card = self.card else { return }
        if SetBuilder.shared.pinnedCards.contains(card) {
            SetBuilder.shared.unpinCard(card)
        } else {
            SetBuilder.shared.pinCard(card)
        }
        setupPinButton()
    }
    
    @objc func doExclude(_ sender: UIBarButtonItem) {
        guard let card = self.card else { return }
        if CardData.shared.excludedCards.contains(card), let index = CardData.shared.excludedCards.firstIndex(of: card) {
            CardData.shared.excludedCards.remove(at: index)
        } else {
            CardData.shared.excludedCards = (CardData.shared.excludedCards + [card]).sorted(by: Utilities.alphabeticSort(card1:card2:))
        }
        setupPinButton()
    }
}

