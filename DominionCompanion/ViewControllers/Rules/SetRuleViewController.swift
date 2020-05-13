//
//  SetRuleViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 11/3/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetRuleViewController: UITableViewController {
    let defaultRule = CardRule(type: .number, property: .cost, operation: .greater, comparisonValue: "0")
    var rules: [CardRule] = []
    
    var existingRuleIndex: Int?
    
    var ruleEngine: RuleEngine = RuleEngine.shared
    
    var cardOperation: FilterOperation = .greater
    var cardValue: Int = 0
    
    var matchingCards: [Card] {
        get {
            return rules.reduce(CardData.shared.cardsFromChosenExpansions) { (cards, rule) -> [Card] in
                let cardSet = Set(cards)
                let matchingFilter = Set(CardData.shared.cardsFromChosenExpansions.filter { rule.matches(card: $0) })
                return Array(cardSet.intersection(matchingFilter))
            }
        }
    }
    
    override func viewDidLoad() {
        let barButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRule)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFilter(_:)))
        ]
        self.navigationItem.rightBarButtonItems = barButtonItems
        self.navigationItem.title = "Set Rule"
        
        if existingRuleIndex == nil, rules.count == 0 {
            rules.append(defaultRule)
        } else if let index = existingRuleIndex {
            let rule = ruleEngine.rules[index]
            rules = rule.cardRules
            cardOperation = rule.operation
            cardValue = rule.value
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return rules.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Cards to match in set"
        case 2:
            return "Conditions"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail") else { return UITableViewCell() }
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = "\(self.matchingCards.count)"
            cell.textLabel?.text = "Matching Cards"
            return cell
        case 1:
            return getRangeCell(tableView)
        default:
            return getFilterCell(tableView, row: indexPath.row)
        }
    }
    
    func getRangeCell(_ tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rangeCell") as? RangeCell else { return UITableViewCell() }
        cell.delegate = self
        guard let index = existingRuleIndex else { return cell }
        let rule = ruleEngine.rules[index]
        cell.setup(operation: rule.operation, value: rule.value)
        return cell
    }
    
    func getFilterCell(_ tableView: UITableView, row: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell") as? FilterCell else { return UITableViewCell() }
        cell.delegate = self
        cell.index = row
        cell.setup(rules[row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard rules.count > 1 else { return nil }
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            self.rules.remove(at: indexPath.row)
            tableView.reloadData()
            completion(true)
        }
        delete.image = UIImage(named: "Delete")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @objc func addFilter(_ sender: UIBarButtonItem) {
        rules.append(defaultRule)
        tableView.reloadData()
    }
    
    @objc func saveRule(_ sender: UIBarButtonItem) {
        let rule = SetRule(value: cardValue, operation: cardOperation, cardRules: rules)
        if let index = existingRuleIndex {
            ruleEngine.updateRule(index, rule)
        } else {
            ruleEngine.addRule(rule)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CardsViewController else { return }
        destination.rawCardData = matchingCards
    }
}

// MARK: Range Cell Delegate
extension SetRuleViewController: RangeDelegate {
    func setOperation(_ operation: FilterOperation) {
        cardOperation = operation
    }
    
    func setValue(_ value: Int) {
        cardValue = value
    }
    func setRange(lower: Int, upper: Int) {
        return
    }
}

//MARK: Filter Cell Delegate
extension SetRuleViewController: FilterCellDelegate {
    func updateFilter(at index: Int, rule: CardRule) {
        rules[index] = rule
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
