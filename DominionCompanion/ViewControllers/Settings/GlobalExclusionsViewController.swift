//
//  GlobalExclusionsViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/19/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class GlobalExclusionViewController: UITableViewController {
    override func viewDidLoad() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewExclusion(_:)))
        self.navigationItem.rightBarButtonItem = add
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardData.shared.excludedCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = CardData.shared.excludedCards[indexPath.row].name
        return cell
    }
    
    @objc func addNewExclusion(_ sender: UIBarButtonItem) {
        
    }
}
