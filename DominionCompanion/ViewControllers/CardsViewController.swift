//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController, UISearchBarDelegate {
    
    var cardsToDisplay : [Card]? = nil
    var rawCardData : [Card] = []
    var cardData: [Card]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rawCardData = self.cardsToDisplay ?? CardData.shared.allCards
        self.filterCards("")
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = cardData?.count else { return 0 }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else {
            print("couldn't get a cell")
            return UITableViewCell()
        }
        guard let index = indexPath.last else {
            cell.textLabel?.text = "Error With Index"
            return cell
        }
        if let card = self.cardData?[index] {
            cell.setData(card)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "ViewCard",
            let cardVC = segue.destination as? CardViewController,
            let card = self.cardData?[indexPath.row]
        {
            cardVC.card = card
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterCards(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

