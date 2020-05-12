//
//  GameplaySetupViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/26/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class GameplaySetupViewController: UITableViewController {
    var setModel: SetModel?
    
    var tableData: [GameplaySection] = []
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSet))
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        guard let model = setModel else { return }
        tableData = model.getSections(tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { tableData[section].title }
    
    override func numberOfSections(in tableView: UITableView) -> Int { tableData.count }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tableData[section].rows.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableData[indexPath.section].rows[indexPath.row]
    }
    
    @objc func saveSet() {
        guard let model = setModel else { return }
        
        SavedSets.shared.saveSet(name: "example", model: model)
    }
}
