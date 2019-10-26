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
    let allSettings: [MenuSection] = [
        MenuSection(title: "Additional Mechanics", items: [
            MenuItem(title: "Landmarks", destinationType: .list, destination: "", saveKey: "settings_numberOfLandmarks", values: ["0", "1", "2"]),
            MenuItem(title: "Events", destinationType: .list, destination: "", saveKey: "settings_numberOfEvents", values: ["0", "1", "2"])
        ]),
        MenuSection(title: "Miscellaneous", items: [
            MenuItem(title: "Global Exclude List", destinationType: .viewController, destination: "GlobalExclusions"),
        ])
    ]
    override func viewDidLoad() {
        self.navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return allSettings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSettings[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allSettings[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = allSettings[indexPath.section].items[indexPath.row]
        let cell = UITableViewCell()
        switch menuItem.destinationType {
        case .viewController:
            cell.textLabel?.text = menuItem.title
            cell.accessoryType = .disclosureIndicator
        case .list:
            cell.textLabel?.text = "\(menuItem.title) (\(UserDefaults.standard.string(forKey: menuItem.saveKey) ?? ""))"
            cell.accessoryType = .disclosureIndicator
        default:
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = allSettings[indexPath.section].items[indexPath.row]
        switch menuItem.destinationType {
        case .list:
            self.performSegue(withIdentifier: "ShowSettingsList", sender: menuItem)
        case .viewController:
            self.performSegue(withIdentifier: menuItem.destination, sender: self)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? ListSettingTableViewController,
            let menuItem = sender as? MenuItem
            else { return }
        destination.saveKey = menuItem.saveKey
        destination.values = menuItem.values
    }
}

//struct Settings: Codable {
//    var excluded: [String]
//}
