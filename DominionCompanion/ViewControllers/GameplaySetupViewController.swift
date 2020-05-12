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
    var savedSetName: String = ""
    
    var displayingSavedSet = false
    
    var setModel: SetModel?
    
    var tableData: [GameplaySection] = []
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        
        guard let model = setModel else { return }
        tableData = model.getSections(tableView: tableView)
        
        guard !displayingSavedSet else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSet))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { tableData[section].title }
    
    override func numberOfSections(in tableView: UITableView) -> Int { tableData.count }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { tableData[section].rows.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableData[indexPath.section].rows[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AttributedCardCell else { return }
        performSegue(withIdentifier: "ViewCard", sender: cell.card)
    }
    
    @objc func saveSet() {
        let alert = UIAlertController(title: "Save Set", message: "Save this set to recall it later for setup", preferredStyle: .alert)
        alert.addTextField { $0.delegate = self }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.savedSetName = ""
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let model = self.setModel else { return }
            
            SavedSets.shared.saveSet(name: self.savedSetName, model: model)
            self.savedSetName = ""
        }))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CardViewController, let card = sender as? Card else { return }
        vc.card = card
    }
}

extension GameplaySetupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        savedSetName = textField.text ?? ""
    }
}
