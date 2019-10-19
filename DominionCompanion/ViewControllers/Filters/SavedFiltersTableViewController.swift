//
//  SavedFiltersTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 10/19/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SavedFiltersTableViewController: UITableViewController {
    
    var tempFilterName: String = ""
    
    var savedFilters: [SavedFilter] = [] {
        didSet {
            FilterEngine.shared.saveFilters(self.savedFilters)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFilterSet(_:)))
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedFilters = FilterEngine.shared.loadSavedFilters()
    }
    
    
    @objc func saveFilterSet(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Save", message: "Save Current Filters", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.delegate = self
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in alert.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.savedFilters.append(SavedFilter(name: self.tempFilterName, filters: FilterEngine.shared.filters))
            self.tempFilterName = ""
        }))
        self.present(alert, animated: true)
    }

    // MARK: TableViewData
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = savedFilters[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in
                self.savedFilters.remove(at: indexPath.row)
                completion(true)
            }),
            UIContextualAction(style: .normal, title: "Load", handler: { (action, view, completion) in
                FilterEngine.shared.filters = self.savedFilters[indexPath.row].filters
                self.navigationController?.popViewController(animated: true)
            })
        ])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = savedFilters[indexPath.row]
        guard let filtersVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetFiltersViewController") as? SetFiltersViewController else {
            return
        }
        filtersVC.filterEngine = FilterEngine(filter)
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
}

extension SavedFiltersTableViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        tempFilterName = textField.text ?? ""
    }
}
