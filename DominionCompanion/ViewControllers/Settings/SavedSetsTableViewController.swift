//
//  SavedSetsTableViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/11/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SavedSetsTableViewController: UITableViewController {
    var searchController: UISearchController = UISearchController()
    
    var segmentedControl = UISegmentedControl(items: ["Saved", "Recommended"])
    
    var searchText = ""
    
    var rawSavedSets: [SavedSet] {
        SavedSets.shared.savedSets.filter{savedSet in
            guard searchText != "" else { return true }
            let matchesExpansion = savedSet.getSetModel().expansions.first { $0.lowercased().contains(searchText.lowercased()) } != nil
            return matchesExpansion || savedSet.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var rawRecommendedSets: [ShareableSet] {
        RecommendedSets.shared.sets.filter { shareableSet in
            guard searchText != "" else { return true }
            let matchesExpansion = shareableSet.getSetModel().expansions.first { $0.lowercased().contains(searchText.lowercased()) } != nil
            return matchesExpansion || shareableSet.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    var savedSets: [SavedSet] = []
    var recommendedSets: [ShareableSet] = []

    func updateSets() {
        DispatchQueue.global().async {
            self.savedSets = self.rawSavedSets
            self.recommendedSets = self.rawRecommendedSets
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        self.navigationItem.title = "Sets"
        navigationItem.largeTitleDisplayMode = .never
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedSelected(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSets()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { segmentedControl.selectedSegmentIndex == 0 ? savedSets.count : recommendedSets.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedSetCell") as? SavedSetCell else { return UITableViewCell() }
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.configure(savedSets[indexPath.row])
        } else {
            cell.configure(recommendedSets[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard segmentedControl.selectedSegmentIndex == 0 else { return nil }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            SavedSets.shared.delete(savedSet: self.savedSets[indexPath.row])
            self.updateSets()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = segmentedControl.selectedSegmentIndex == 0 ? savedSets[indexPath.row].getSetModel() : recommendedSets[indexPath.row].getSetModel()
        performSegue(withIdentifier: "SetupSet", sender: model)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let model = sender as? SetModel, let vc = segue.destination as? GameplaySetupViewController else { return }
        vc.displayingSavedSet = true
        vc.setModel = model
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentedControl
    }
    
    @objc func segmentedSelected(_ sender: UISegmentedControl) {
        updateSets()
    }
}

extension SavedSetsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        updateSets()
    }
}
