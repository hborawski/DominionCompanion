//
//  SavedFiltersTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/19/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SavedRulesTableViewController: UITableViewController {
    
    var tempRuleName: String = ""
    
    var savedRules: [SavedRule] = [] {
        didSet {
            RuleEngine.shared.saveRules(self.savedRules)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRuleSet(_:)))
        ]
        self.navigationItem.title = "Saved Rule Sets"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedRules = RuleEngine.shared.loadSavedRules()
    }
    
    
    @objc func saveRuleSet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Save", message: "Save Current Rules", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.delegate = self
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in alert.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.savedRules.append(SavedRule(name: self.tempRuleName, rules: RuleEngine.shared.rules))
            self.tempRuleName = ""
        }))
        self.present(alert, animated: true)
    }

    // MARK: TableViewData
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRules.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") else { return UITableViewCell() }
        cell.textLabel?.text = savedRules[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let replace = UIContextualAction(style: .normal, title: "Replace", handler: { (action, view, completion) in
            RuleEngine.shared.rules = self.savedRules[indexPath.row].rules
            self.navigationController?.popViewController(animated: true)
        })
        replace.backgroundColor = .systemBlue
        let append = UIContextualAction(style: .normal, title: "Append", handler: { (action, view, completion) in
            RuleEngine.shared.rules = RuleEngine.shared.rules + self.savedRules[indexPath.row].rules
            self.navigationController?.popViewController(animated: true)
        })
        append.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
                self.savedRules.remove(at: indexPath.row)
                completion(true)
            }),
            replace,
            append
        ])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rename = UIContextualAction(style: .normal, title: "Rename") { (action, view, completion) in
            let renameAlert = UIAlertController(title: "Rename", message: "Rename saved rule set", preferredStyle: .alert)
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in renameAlert.dismiss(animated: true, completion: nil)}))
            renameAlert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { _ in
                let savedRule = self.savedRules[indexPath.row]
                let rule = SavedRule(name: self.tempRuleName, rules: savedRule.rules, uuid: savedRule.uuid)
                self.savedRules[indexPath.row] = rule
                self.tempRuleName = ""
            }))
            renameAlert.addTextField { (field) in
                field.delegate = self
            }
            self.present(renameAlert, animated: true)
        }
        rename.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions: [rename])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rules = savedRules[indexPath.row]
        guard let rulesVC = UIStoryboard(name: "Rules", bundle: nil).instantiateViewController(withIdentifier: "SetRulesViewController") as? SetRulesViewController else {
            return
        }
        rulesVC.ruleEngine = RuleEngine(rules)
        self.navigationController?.pushViewController(rulesVC, animated: true)
    }
    
}

extension SavedRulesTableViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        tempRuleName = textField.text ?? ""
    }
}