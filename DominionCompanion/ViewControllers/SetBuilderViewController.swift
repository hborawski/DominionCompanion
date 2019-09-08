//
//  SetBuilderViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    var maxCards = 10 - 1
    var pinnedCards: [Card] = []
    var randomCards: [Card] = []

    var fullSet: [Card] {
        get {
            guard randomCards.count > 0 else { return [] }
            let numberToPick = maxCards - pinnedCards.count
            return pinnedCards + Array(randomCards[0...numberToPick])
        }
    }
    
    var poolOfCards: [Card] = []
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)

        self.poolOfCards = FilterEngine.shared.matchAnyFilter
        let matchingCards = FilterEngine.shared.matchAllFilters
        self.randomCards = Array(matchingCards.shuffled()[0...(matchingCards.count > maxCards ? maxCards : (matchingCards.count - 1))])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.poolOfCards = FilterEngine.shared.matchAnyFilter
        self.tableView.reloadData()
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSet(_ sender: UIButton) {
        FilterEngine.shared.getMatchingSet(self.pinnedCards) { cards in
            self.randomCards = cards.filter{ !self.pinnedCards.contains($0) }
            self.tableView.reloadData()
        }
    }    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Set" : "Pool of Cards"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.fullSet.count
        case 1:
            return self.poolOfCards.count
        default:
            return 0
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = indexPath.section == 0 ? self.fullSet[indexPath.row] : self.poolOfCards[indexPath.row]
        cell.setData(card, favorite: self.pinnedCards.contains(card))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let card = self.fullSet[indexPath.row]
            if self.pinnedCards.contains(card) {
                if let pinnedIndex = self.pinnedCards.index(of: card) {
                    self.pinnedCards.remove(at: pinnedIndex)
                }
            } else {
                self.pinnedCards.append(card)
            }
        case 1:
            let card = self.poolOfCards[indexPath.row]
            if nil == self.pinnedCards.index(of: card) {
                self.pinnedCards.append(card)
            }
        default:
            break
        }
        self.tableView.reloadData()
    }

    // MARK: 3D Touch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        
        guard let cardViewController = storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController else { return nil }
        
        cardViewController.card = indexPath.section == 0 ? self.fullSet[indexPath.row] : self.poolOfCards[indexPath.row]
        
        return cardViewController
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
