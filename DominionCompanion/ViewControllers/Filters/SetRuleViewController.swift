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
    var filters: [PropertyFilter] = []
    
    var existingRuleIndex: Int?
    
    var ruleEngine: RuleEngine = RuleEngine.shared
    
    var cardOperation: FilterOperation = .greater
    var cardValue: Int = 0
    
    override func viewDidLoad() {
        let barButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRule)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFilter(_:)))
        ]
        self.navigationItem.rightBarButtonItems = barButtonItems
        
        if existingRuleIndex == nil, filters.count == 0 {
            filters.append(NumberFilter(property: .cost, value: "0", operation: .greater))
        } else if let index = existingRuleIndex {
            filters = [ruleEngine.rules[index].propertyFilter]
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return filters.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
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
        cell.setup(filters[row])
        return cell
    }
    
    @objc func addFilter(_ sender: UIBarButtonItem) {
        filters.append(NumberFilter(property: .cost, value: "0", operation: .greater))
        tableView.reloadData()
    }
    
    @objc func saveRule(_ sender: UIBarButtonItem) {
        let rule = SetRule(value: cardValue, operation: cardOperation, propertyFilter: filters[0])
        if let index = existingRuleIndex {
            ruleEngine.updateRule(index, rule)
        } else {
            ruleEngine.addRule(rule)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

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

extension SetRuleViewController: FilterCellDelegate {
    func updateFilter(at index: Int, filter: PropertyFilter) {
        filters[index] = filter
    }
}
