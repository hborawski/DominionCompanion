//
//  SettingsTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/19/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(excludeNewCard(_:)))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Global Exclusions"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "GlobalExclusions", sender: self)
            return
        default:
            return
        }
    }
    
    @objc func excludeNewCard(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ExcludeCard", sender: self)
    }
}


struct Settings: Codable {
    var excluded: [String]
}
