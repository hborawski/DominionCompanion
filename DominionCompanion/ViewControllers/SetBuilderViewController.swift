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
    
    var currentSet: [SetBuilderSection] = []
    
    var refreshControl = UIRefreshControl()
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        if !SetBuilder.shared.setComplete {
            self.shuffleSet()
        }
        let settings = UIBarButtonItem(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(openSettings(_:)))
        self.navigationItem.rightBarButtonItems = [settings]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showShareMenu))
        gameplaySetupButton.layer.cornerRadius = 6.0
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(shuffleSet), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentSet = SetBuilder.shared.currentSet
        self.tableView.reloadData()
        rulesButton.setTitle("Rules (\(RuleEngine.shared.rules.count))", for: .normal)
        toggleSetupButton()
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSetButtonTapped(_ sender: UIButton) {
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }
    
    @objc func openSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowSettings", sender: self)
    }
    
    @objc func showShareMenu() {
        let alertController = UIAlertController(
            title: "Set Sharing",
            message: "Share the current set, or import a friend's set using a QR code and your devices camera.",
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(title: "Scan a code", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ScanQRCode", sender: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Generate a code", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "GenerateQRCode", sender: SetBuilder.shared.getFinalSet().getShareable())
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true)
    }
    
    @objc func shuffleSet() {
        self.tableView.reloadData()
        SetBuilder.shared.shuffleSet {
            self.refreshControl.endRefreshing()
            self.currentSet = SetBuilder.shared.currentSet
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentSet[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentSet.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = currentSet[section]
        return (refreshControl.isRefreshing && section.canShuffle) ? 1 : section.cards.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "ViewCard", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = currentSet[indexPath.section]
        if refreshControl.isRefreshing && section.canShuffle {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell") ?? UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell else { return UITableViewCell() }
        let card = section.rows[indexPath.row]
        cell.setData(card.card, favorite: card.pinned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cardData = currentSet[indexPath.section].rows[indexPath.row]
        let pin = UIContextualAction(style: .normal, title: cardData.pinned ? "Unpin" : "Pin") { (action, view, completion) in
            guard self.refreshControl.isRefreshing == false else { return }
            cardData.pinAction()
            tableView.reloadData()
            self.toggleSetupButton()
            self.currentSet = SetBuilder.shared.currentSet
            completion(true)
        }
        pin.image = cardData.pinned ? UIImage(named: "Delete") : UIImage(named: "Checkmark")
        pin.backgroundColor = cardData.pinned ? .systemRed : .systemBlue
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == "ViewCard",
            let selectedCell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: selectedCell),
            let cardVC = segue.destination as? CardViewController
        {
            cardVC.card = currentSet[indexPath.section].rows[indexPath.row].card
            return
        }
        if
            segue.identifier == "GoToGameplaySetup",
            let gameplayVC = segue.destination as? GameplaySetupViewController
        {
            gameplayVC.setModel = SetBuilder.shared.getFinalSet()
            return
        }
        if
            segue.identifier == "GenerateQRCode",
            let shareVC = segue.destination as? ShareSetViewController,
            let set = sender as? ShareableSet
        {
            shareVC.set = set
            return
        }
        
        if segue.identifier == "ScanQRCode", let scanVC = segue.destination as? ScanSetViewController {
            scanVC.importSucceeded = {
                self.viewWillAppear(true)
            }
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
