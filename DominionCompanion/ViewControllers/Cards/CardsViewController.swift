//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController {
    var showSearch = false
    
    var excludeMode: Bool = false
    
    var cardsToDisplay : [Card]? = nil
    var rawCardData : [Card] = []
    var cardData: [Card] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        self.rawCardData = self.cardsToDisplay ?? CardData.shared.allCards
        self.filterCards("")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Card name..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showSearch {
            searchController.searchBar.becomeFirstResponder()
            showSearch = false
        }
    }
    
    func filterCards(_ searchText: String) {
        self.cardData = self.rawCardData
            .filter { card -> Bool in
                guard searchText != "" else { return true }
                return card.name.lowercased().contains(searchText.lowercased())
            }
            .sorted(by: Utilities.alphabeticSort(card1:card2:))
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cardData.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = self.cardData[indexPath.row]
        cell.setData(card)
        if excludeMode, CardData.shared.excludedCards.contains(card) {
            cell.accessoryView = UIImageView(image: UIImage(named: "Exclude"))
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let card = self.cardData[indexPath.row]
        if excludeMode {
            let excluded = CardData.shared.excludedCards.contains(card)
            let pin = UIContextualAction(style: .normal, title:  excluded ? "Exclude" : "Include") { (action, view, completion) in
                if CardData.shared.excludedCards.contains(card), let index = CardData.shared.excludedCards.firstIndex(of: card) {
                    CardData.shared.excludedCards.remove(at: index)
                } else {
                    CardData.shared.excludedCards = (CardData.shared.excludedCards + [card]).sorted(by: Utilities.alphabeticSort(card1:card2:))
                }
                tableView.reloadData()
                completion(true)
            }
            pin.image = excluded ? UIImage(named: "Delete") : UIImage(named: "Exclude")
            pin.backgroundColor = excluded ? .systemRed : .systemBlue
            return UISwipeActionsConfiguration(actions: [pin])
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "ViewCard", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "ViewCard",
            let cardVC = segue.destination as? CardViewController
        {
            cardVC.card = self.cardData[indexPath.row]
            cardVC.excludeMode = excludeMode
        }
    }
}

extension CardsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterCards(searchController.searchBar.text ?? "")
    }
}
