//
//  SetBuilderViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filtersButton: UIButton!
    
    var shuffling: Bool = false
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shuffleSet()
        let settings = UIBarButtonItem(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(openSettings(_:)))
        self.navigationItem.rightBarButtonItems = [settings]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        filtersButton.setTitle("Filters(\(FilterEngine.shared.filters.count))", for: .normal)
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSet(_ sender: UIButton) {
        self.shuffleSet()
    }
    
    @objc func openSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowSettings", sender: self)
    }
    
    func shuffleSet() {
        guard shuffling == false else { return }
        self.shuffling = true
        self.tableView.reloadData()
        SetBuilder.shared.shuffleSet {
            self.shuffling = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set"
        case 1:
            return FilterEngine.shared.filters.count > 0 ? "Cards Matching Any Filter (\(FilterEngine.shared.matchAnyFilter.count))" : "All Cards (\(CardData.shared.chosenExpansions.count))"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let set = SetBuilder.shared.fullSet
            print(set)
            return shuffling ? 1 : SetBuilder.shared.fullSet.count
        case 1:
            return SetBuilder.shared.cardPool.count
        default:
            return 0
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shuffling == true && indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell") ?? UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = getCardForIndexPath(indexPath)
        cell.setData(card, favorite: SetBuilder.shared.pinnedCards.contains(card))
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let card = getCardForIndexPath(indexPath)
        let contains = SetBuilder.shared.pinnedCards.contains(card)
        let pin = UIContextualAction(style: .normal, title: contains ? "Unpin" : "Pin") { (action, view, completion) in
            guard self.shuffling == false else { return }
            if contains {
                SetBuilder.shared.unpinCard(card)
            } else {
                SetBuilder.shared.pinCard(card)
            }
            tableView.reloadData()
            completion(true)
        }
        pin.image = contains ? UIImage(named: "Delete") : UIImage(named: "Checkmark")
        pin.backgroundColor = contains ? .systemRed : .systemBlue
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "ViewCard",
            let cardVC = segue.destination as? CardViewController
        {
            cardVC.card = getCardForIndexPath(indexPath)
        }
    }
    //MARK: Helpers
    private func getCardForIndexPath(_ indexPath: IndexPath) -> Card {
        return indexPath.section == 0 ? SetBuilder.shared.fullSet[indexPath.row] : SetBuilder.shared.cardPool[indexPath.row]
    }
}
