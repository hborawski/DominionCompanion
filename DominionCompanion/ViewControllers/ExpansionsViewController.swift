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
    
    var chosenExpansions : [String] = [] {
        didSet {
            UserDefaults.standard.setValue(self.chosenExpansions, forKey: "expansions")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let expansions = UserDefaults.standard.array(forKey: "expansions") as? [String] else { return }
        self.chosenExpansions = expansions
        
    }
    
    // MARK: TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardData.shared.expansions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") else { return UITableViewCell() }
        let expansion = CardData.shared.expansions[indexPath.row]
        cell.textLabel?.text = expansion
        cell.accessoryType = self.chosenExpansions.contains(expansion) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expansion = CardData.shared.expansions[indexPath.row]
        guard self.chosenExpansions.contains(expansion) else {
            self.chosenExpansions.append(expansion)
            return
        }
        self.chosenExpansions = self.chosenExpansions.filter { $0 != expansion }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let view = UIContextualAction(style: .normal, title: "View Cards") { (action, view, completion) in
            let expansion = CardData.shared.expansions[indexPath.row]
            let cards = CardData.shared.allCards.filter { $0.expansion == expansion }
            self.performSegue(withIdentifier: "ViewCards", sender: cards)
        }
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
