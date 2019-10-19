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
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doPin(_:)))
        let remove = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(doPin(_:)))
        if let card = self.card, SetBuilder.shared.pinnedCards.contains(card) {
            self.navigationItem.rightBarButtonItem = remove
        } else {
            self.navigationItem.rightBarButtonItem = add
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
}

