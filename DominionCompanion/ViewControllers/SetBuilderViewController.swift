//
//  SetBuilderViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class SetBuilderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var rulesButton: UIButton!
    @IBOutlet var gameplaySetupButton: UIButton!
    
    var shuffling: Bool = false
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shuffleSet()
        let settings = UIBarButtonItem(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(openSettings(_:)))
        self.navigationItem.rightBarButtonItems = [settings]
        gameplaySetupButton.layer.cornerRadius = 6.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        rulesButton.setTitle("Rules (\(RuleEngine.shared.rules.count))", for: .normal)
        toggleSetupButton()
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSet(_ sender: UIButton) {
        self.shuffleSet()
    }
    
    @objc func openSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowSettings", sender: self)
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
        return SetBuilder.shared.currentSet[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SetBuilder.shared.currentSet.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = SetBuilder.shared.currentSet[section]
        return (shuffling && section.canShuffle) ? 1 : section.cards.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = SetBuilder.shared.currentSet[indexPath.section]
        if shuffling == true && section.canShuffle {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell") ?? UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = section.rows[indexPath.row]
        cell.setData(card.card, favorite: card.pinned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cardData = SetBuilder.shared.currentSet[indexPath.section].rows[indexPath.row]
        let pin = UIContextualAction(style: .normal, title: cardData.pinned ? "Unpin" : "Pin") { (action, view, completion) in
            guard self.shuffling == false else { return }
            cardData.pinAction()
            tableView.reloadData()
            self.toggleSetupButton()
            completion(true)
        }
        pin.image = cardData.pinned ? UIImage(named: "Delete") : UIImage(named: "Checkmark")
        pin.backgroundColor = cardData.pinned ? .systemRed : .systemBlue
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) else { return }
        if segue.identifier == "ViewCard",
            let cardVC = segue.destination as? CardViewController
        {
            cardVC.card = SetBuilder.shared.currentSet[indexPath.section].rows[indexPath.row].card
            return
        }
        if segue.identifier == "GoToGameplaySetup", let gameplayVC = segue.destination as? GameplaySetupViewController {
            gameplayVC.setModel = SetBuilder.shared.getFinalSet()
            return
        }
    }
}

extension SetBuilderViewController {
    @IBAction func goToGameplaySetup(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGameplaySetup", sender: self)
    }
    
    func toggleSetupButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                if self.gameplaySetupButton.isHidden, SetBuilder.shared.setComplete {
                    self.gameplaySetupButton.isHidden = false
                } else if !self.gameplaySetupButton.isHidden, !SetBuilder.shared.setComplete {
                    self.gameplaySetupButton.isHidden = true
                }
            }
        }
    }
}
