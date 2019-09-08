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
    
    var shuffling: Bool = false
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForPreviewing(with: self, sourceView: tableView)

        self.shuffleSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSet(_ sender: UIButton) {
        self.shuffleSet()
    }
    
    func shuffleSet() {
        guard shuffling == false else { return }
        self.shuffling = true
        self.tableView.reloadData()
        SetBuilder.shared.shuffleSet {
            self.shuffling = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set"
        case 1:
            return FilterEngine.shared.filters.count > 0 ? "Cards Matching Any Filter" : "All Cards"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return shuffling ? 1 : SetBuilder.shared.fullSet.count
        case 1:
            return SetBuilder.shared.cardPool.count
        default:
            return 0
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shuffling == true && indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell") ?? UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = indexPath.section == 0 ? SetBuilder.shared.fullSet[indexPath.row] : SetBuilder.shared.cardPool[indexPath.row]
        cell.setData(card, favorite: SetBuilder.shared.pinnedCards.contains(card))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard shuffling == false else { return }
        switch indexPath.section {
        case 0:
            let card = SetBuilder.shared.fullSet[indexPath.row]
            if SetBuilder.shared.pinnedCards.contains(card) {
                SetBuilder.shared.unpinCard(card)
            } else {
                SetBuilder.shared.pinCard(card)
            }
        case 1:
            let card = SetBuilder.shared.cardPool[indexPath.row]
            SetBuilder.shared.pinCard(card)
        default:
            break
        }
        self.tableView.reloadData()
    }

    // MARK: 3D Touch
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        previewingContext.sourceRect = cell.frame
        
        guard let cardViewController = storyboard?.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController else { return nil }
        
        cardViewController.card = indexPath.section == 0 ? SetBuilder.shared.fullSet[indexPath.row] : SetBuilder.shared.cardPool[indexPath.row]
        
        return cardViewController
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
