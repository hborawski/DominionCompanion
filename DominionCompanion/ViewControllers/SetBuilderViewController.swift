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
    
    var currentSet: [SetBuilderSection] = []
    
    var refreshControl = UIRefreshControl()
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
        if !SetBuilder.shared.setComplete {
            self.shuffleSet()
        }
        let gameplaySetup = UIBarButtonItem.init(barButtonSystemItem: .play, target: self, action: #selector(goToGameplaySetup(_:)))
        self.navigationItem.rightBarButtonItems = [gameplaySetup]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showShareMenu))
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(shuffleSet), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSetDisplay()
        rulesButton.setTitle("Rules (\(RuleEngine.shared.rules.count))", for: .normal)
    }
    
    // MARK: Button Handlers
    @IBAction func shuffleSetButtonTapped(_ sender: UIButton) {
        guard !SetBuilder.shared.setComplete else { return }
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }
    
    // MARK: Alerts
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
    
    func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: "Error Building Set",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "Ok", style: .cancel, handler: {_ in alertController.dismiss(animated: true, completion: nil)}
        ))
        self.present(alertController, animated: true, completion: completion)
    }
    
    // MARK: Shuffling
    @objc func shuffleSet() {
        tableView.reloadData()
        SetBuilder.shared.shuffleSet { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    switch error {
                    case .failedToBuild(let reason):
                        self.showErrorAlert(message: reason) {
                            self.updateSetDisplay()
                        }
                    }
                case .success:
                    self.updateSetDisplay()
                }
            }
        }
    }
    
    func updateSetDisplay() {
        self.refreshControl.endRefreshing()
        self.currentSet = SetBuilder.shared.currentSet
        self.tableView.reloadData()
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
        self.performSegue(withIdentifier: "ViewCard", sender: indexPath)
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
            self.updateSetDisplay()
            completion(true)
        }
        pin.image = cardData.pinned ? UIImage(named: "Delete") : UIImage(named: "Checkmark")
        pin.backgroundColor = cardData.pinned ? .systemRed : .systemBlue
        return UISwipeActionsConfiguration(actions: [pin])
    }
    
    // MARK: Segue Prep
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == "ViewCard",
            let indexPath = sender as? IndexPath,
            let cardVC = segue.destination as? CardViewController
        {
            cardVC.card = currentSet[indexPath.section].rows[indexPath.row].card
            return
        }
        if
            segue.identifier == "GoToGameplaySetup",
            let gameplayVC = segue.destination as? GameplaySetupViewController
        {
            let finalSet = SetBuilder.shared.getFinalSet()
            for card in finalSet.cards {
                SetBuilder.shared.pin(card)
            }
            gameplayVC.setModel = finalSet
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
                self.updateSetDisplay()
            }
        }
    }
}

extension SetBuilderViewController {
    @IBAction func goToGameplaySetup(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "GoToGameplaySetup", sender: self)
    }
}
