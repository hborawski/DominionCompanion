//
//  ExpansionsViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/14/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class ExpansionsViewController : UITableViewController {
    // MARK: TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardData.shared.allExpansions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") else { return UITableViewCell() }
        let expansion = CardData.shared.allExpansions[indexPath.row]
        cell.textLabel?.text = expansion
        cell.accessoryType = Settings.shared.chosenExpansions.contains(expansion) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expansion = CardData.shared.allExpansions[indexPath.row]
        guard Settings.shared.chosenExpansions.contains(expansion) else {
            Settings.shared.chosenExpansions.append(expansion)
            return tableView.reloadData()
        }
        Settings.shared.chosenExpansions = Settings.shared.chosenExpansions.filter { $0 != expansion }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let view = UIContextualAction(style: .normal, title: "View Cards") { (action, view, completion) in
            let expansion = CardData.shared.allExpansions[indexPath.row]
            let cards = CardData.shared.kingdomCards.filter { $0.expansion == expansion }
            self.performSegue(withIdentifier: "ViewCards", sender: cards)
        }
        view.image = UIImage(named: "Card")
        view.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [view])
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, identifier == "ViewCards", let destination = segue.destination as? CardsViewController else { return }
        guard let cards = sender as? [Card] else { return }
        destination.cardsToDisplay = cards
    }
}
