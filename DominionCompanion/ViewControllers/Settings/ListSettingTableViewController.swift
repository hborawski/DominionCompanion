//
//  ListSettingTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class ListSettingTableViewController: UITableViewController {
    var values: [String] = []
    var saveKey: String = ""
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(values[indexPath.row])"
        cell.accessoryType = isSavedValue(indexPath) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = values[indexPath.row]
        UserDefaults.standard.set(value, forKey: saveKey)
        tableView.reloadData()
    }
    
    func isSavedValue(_ indexPath: IndexPath) -> Bool {
        guard let savedValue = UserDefaults.standard.string(forKey: saveKey) else {
            return false
        }
        return values[indexPath.row] == savedValue
    }
}
