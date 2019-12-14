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
    var setModel: SetModel?
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "AttributedCardCell", bundle: nil), forCellReuseIdentifier: "attributedCardCell")
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "In Supply"
        case 1:
            return "Not In Supply"
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = setModel else { return 0 }
        switch section {
        case 0:
            return model.cards.count
        case 1:
            return model.notInSupply.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let model = setModel,
            let cell = tableView.dequeueReusableCell(withIdentifier: "attributedCardCell") as? AttributedCardCell
        else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let card = model.cards[indexPath.row]
            cell.setData(card)
        case 1:
            let card = model.notInSupply[indexPath.row]
            cell.setData(card)
        default:
            return cell
        }
        return cell
    }
}
