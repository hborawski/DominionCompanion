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
    let tagToKey: [SettingToggle: String] = [
        .colonies: Constants.SaveKeys.settingsColonies,
        .pincards: Constants.SaveKeys.settingsPinCards,
        .showExpansions: Constants.SaveKeys.settingsShowExpansionsWhenBuilding
    ]
    var tagToSwitch: [SettingToggle: UISwitch] = [:]
    let allSettings: [MenuSection] = [
        MenuSection(title: "App Behavior", items: [
            MenuItem(title: "Pin all cards for setup", destinationType: .toggle, destination: "", saveKey: Constants.SaveKeys.settingsPinCards, values: [], tag: .pincards),
            MenuItem(title: "Set Builder Sort Mode", destinationType: .list, destination: "", saveKey: Constants.SaveKeys.settingsSortMode, values: SortMode.allCases.map{ $0.rawValue }),
            MenuItem(title: "Gameplay Setup Sort Mode", destinationType: .list, destination: "", saveKey: Constants.SaveKeys.settingsGameplaySortMode, values: SortMode.allCases.map{ $0.rawValue }),
            MenuItem(title: "Show Expansions in Set Builder", destinationType: .toggle, destination: "", saveKey: Constants.SaveKeys.settingsShowExpansionsWhenBuilding, values: [], tag: .showExpansions)
        ]),
        MenuSection(title: "Additional Mechanics", items: [
            MenuItem(title: "Always Use Colonies", destinationType: .toggle, destination: "", saveKey: Constants.SaveKeys.settingsColonies, values: [], tag: .colonies),
            MenuItem(title: "Landmarks", destinationType: .list, destination: "", saveKey: Constants.SaveKeys.settingsNumLandmarks, values: ["0", "1", "2"]),
            MenuItem(title: "Events", destinationType: .list, destination: "", saveKey: Constants.SaveKeys.settingsNumEvents, values: ["0", "1", "2"]),
            MenuItem(title: "Projects", destinationType: .list, destination: "", saveKey: Constants.SaveKeys.settingsNumProjects, values: ["0", "1", "2"])
        ]),
        MenuSection(title: "Miscellaneous", items: [
            MenuItem(title: "Global Exclude List", destinationType: .viewController, destination: "GlobalExclusions")
        ])
    ]
    override func viewDidLoad() {
        self.navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        for key in tagToKey.keys {
            let s = UISwitch()
            s.tag = key.rawValue
            s.addTarget(self, action: #selector(handleSwitch(_:)), for: .touchUpInside)
            tagToSwitch[key] = s
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") else { return UITableViewCell() }
        let menuItem = allSettings[indexPath.section].items[indexPath.row]
        cell.detailTextLabel?.text = ""
        cell.textLabel?.text = menuItem.title
        cell.selectionStyle = .default
        switch menuItem.destinationType {
        case .viewController:
            cell.accessoryType = .disclosureIndicator
        case .list:
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = UserDefaults.standard.string(forKey: menuItem.saveKey) ?? ""
        case .toggle:
            cell.selectionStyle = .none
            cell.accessoryType = .none
            if let s = tagToSwitch[menuItem.tag!] {
                s.isOn = UserDefaults.standard.bool(forKey: menuItem.saveKey)
                cell.accessoryView = s
            }
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
        destination.navTitle = menuItem.title
    }
    
    @objc func handleSwitch(_ sender: UISwitch) {
        guard let tag = SettingToggle.init(rawValue: sender.tag), let key = tagToKey[tag] else { return }
        UserDefaults.standard.set(sender.isOn, forKey: key)
    }
    
    func makeSwitch(_ menuItem: MenuItem) -> UISwitch {
        guard let tag = menuItem.tag else { return UISwitch() }
        let s = UISwitch()
        s.tag = tag.rawValue
        s.addTarget(self, action: #selector(handleSwitch(_:)), for: .touchUpInside)
        return s
    }
}

enum SettingToggle: Int {
    case colonies = 1
    case pincards = 2
    case showExpansions = 3
}
