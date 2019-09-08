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
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let card = self.card else { return }
        self.nameLabel.text = "\(card.name) - \(card.expansion)"
        self.textLabel?.text = card.text
        if let image = card.image() {
            self.imageView.image = image
        }
    }
    
    @IBAction func close(sender: UIButton?) {
        self.dismiss(animated: true)
    }
}

