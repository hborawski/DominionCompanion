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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail") else { return UITableViewCell() }
        let model = savedSets[indexPath.row].getSetModel()
        let date = savedSets[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        cell.textLabel?.text = "\(savedSets[indexPath.row].name) - \(model.expansions.joined(separator: " | "))"
        cell.detailTextLabel?.text = formatter.string(from: date)
        cell.detailTextLabel?.alpha = 0.5
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = savedSets[indexPath.row].getSetModel()
        performSegue(withIdentifier: "SetupSet", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let model = sender as? SetModel, let vc = segue.destination as? GameplaySetupViewController else { return }
        vc.displayingSavedSet = true
        vc.setModel = model
    }
}
