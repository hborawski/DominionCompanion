//
//  SetRulesViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetRulesViewController: UITableViewController {
    var ruleEngine: RuleEngine = RuleEngine.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var barButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newItem(_:)))
        ]
        
        if !ruleEngine.editing {
            barButtonItems.append(UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(savedFilters(_:))))
        } else {
            barButtonItems.append(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFilter(_:))))
        }
        self.navigationItem.rightBarButtonItems = barButtonItems
        self.navigationItem.title = "Set Rules"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func newItem(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "NewFilter", sender: self)
    }
    
    @objc func savedFilters(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "SavedFilters", sender: self)
    }
    
    @objc func saveFilter(_ sender: UIBarButtonItem) {
        guard let savedFilter = ruleEngine.savedRule else { return }
        let filter = SavedRule(name: savedFilter.name, rules: ruleEngine.rules, uuid: savedFilter.uuid)
        RuleEngine.shared.updateSavedRules(filter)
    }
    
    // MARK: UITableViewController Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ruleEngine.rules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SetFilterCell") as? SetFilterCell else { return UITableViewCell()}
        cell.setData(filter: ruleEngine.rules[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.ruleEngine.removeRule(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filterViewController = segue.destination as? RuleViewController else { return }
        filterViewController.filterEngine = self.ruleEngine
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "EditFilter",
            let filterViewController = segue.destination as? RuleViewController
        {
            filterViewController.existingFilterIndex = indexPath.row
        }
    }
}
