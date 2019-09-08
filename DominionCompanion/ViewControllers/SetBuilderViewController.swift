//
//  SetBuilderViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    var set: [Card] = []
    var filteredCards: [Card] = []
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)

        self.filteredCards = FilterEngine.shared.matchAnyFilter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.filteredCards = FilterEngine.shared.matchAnyFilter
        self.tableView.reloadData()
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSet(_ sender: UIButton) {
        let matchingCards = FilterEngine.shared.matchAllFilters
        self.set = Array(matchingCards.shuffled()[0...(matchingCards.count > 10 ? 10 : (matchingCards.count - 1))])
        self.tableView.reloadData()
    }    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Set" : "Pool of Cards"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.set.count
        case 1:
            return self.filteredCards.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell")!
        let card = indexPath.section == 0 ? self.set[indexPath.row] : self.filteredCards[indexPath.row]
        cell.textLabel?.text = card.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    // MARK: 3D Touch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        
        guard let cardViewController = storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController else { return nil }
        
        cardViewController.card = indexPath.section == 0 ? self.set[indexPath.row] : self.filteredCards[indexPath.row]
        
        return cardViewController
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
