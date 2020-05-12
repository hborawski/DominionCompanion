//
//  SavedSetsTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/11/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SavedSetsTableViewController: UITableViewController {
    var savedSets: [SavedSet] { SavedSets.shared.savedSets }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Saved Sets"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { savedSets.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let model = savedSets[indexPath.row].getSetModel()
        cell.textLabel?.text = "\(savedSets[indexPath.row].name) - \(model.expansions.joined(separator: " | "))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            SavedSets.shared.delete(savedSet: self.savedSets[indexPath.row])
            self.tableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
