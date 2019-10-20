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
        self.navigationItem.title = "Excluded Cards"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardData.shared.excludedCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell") else { return UITableViewCell() }
        cell.textLabel?.text = CardData.shared.excludedCards[indexPath.row].name
        return cell
    }
    
    @objc func addNewExclusion(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ExcludeCards", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardsViewController {
            destination.excludeMode = true
        } else if
            let destination = segue.destination as? CardViewController,
            let selectedCell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: selectedCell)
        {
            destination.excludeMode = true
            destination.card = CardData.shared.excludedCards[indexPath.row]
        }
    }
}
