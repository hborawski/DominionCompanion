//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit
import SafariServices

class CardViewController: UIViewController {
    var card: Card?
    var excludeMode: Bool = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expansionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var relatedButton: UIButton!
    @IBOutlet weak var wikiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let card = self.card else { return }
        
        let expansionGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewExpansionCards(_:)))
        
        setupPinButton()
        
        self.nameLabel.text = card.name
        self.expansionLabel.text = card.expansion
        self.expansionLabel.addGestureRecognizer(expansionGestureRecognizer)
        self.expansionLabel.isUserInteractionEnabled = true
        if let image = card.image() {
            self.imageView.image = image
        }
        
        self.relatedButton.isHidden = card.relatedCards.count == 0
        self.wikiButton.isHidden = Settings.shared.hideWikiLink
    }
    
    func setupPinButton() {
        let exclude = UIBarButtonItem(image: UIImage(named: "Exclude"), style: .plain, target: self, action: #selector(doExclude(_:)))
        let add = UIBarButtonItem(image: UIImage(named: "Checkmark"), style: .plain, target: self, action: #selector(doPin(_:)))
        let remove = UIBarButtonItem(image: UIImage(named: "Delete"), style: .plain, target: self, action: excludeMode ? #selector(doExclude(_:)) : #selector(doPin(_:)))
        guard let card = self.card, card.canPin else { return }
        if !card.pinned, !excludeMode, SetBuilder.shared.setComplete {
            self.navigationItem.rightBarButtonItem = nil
            return
        }
        if
            !excludeMode && card.pinned ||
            excludeMode && CardData.shared.excludedCards.contains(card)
        {
            self.navigationItem.rightBarButtonItem = remove
        } else {
            self.navigationItem.rightBarButtonItem = excludeMode ? exclude : add
        }
    }
    
    @objc func doPin(_ sender: UIBarButtonItem) {
        guard let card = self.card else { return }
        if card.pinned {
            SetBuilder.shared.unpin(card)
        } else {
            SetBuilder.shared.pin(card)
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
    
    @objc func viewExpansionCards(_ sender: UITapGestureRecognizer) {
        guard let card = self.card else { return }
        let cards = CardData.shared.allCards.filter { $0.expansion == card.expansion }
        performSegue(withIdentifier: "ViewCards", sender: cards)
    }
    
    @IBAction func openWikiPage() {
        guard
            let card = self.card,
            let path = card.name.replacingOccurrences(of: " ", with: "_").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "http://wiki.dominionstrategy.com/index.php/\(path)")
        else { return }
        let safariView = SFSafariViewController(url: url)
        navigationController?.present(safariView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let card = self.card, let destination = segue.destination as? CardsViewController else { return }
        destination.rawCardData = (sender as? [Card]) ?? card.relatedCards
    }
}

