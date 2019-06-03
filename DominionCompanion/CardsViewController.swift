//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit

class CardsViewController: UITableViewController, UISearchBarDelegate {
    var rawCardData : [Card]? = []
    var cardData: [Card]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            if let path = Bundle.main.path(forResource: "cards", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonDict = json as? Array<AnyObject> {
                    self.rawCardData = jsonDict.map { Card($0 as! Dictionary<String, AnyObject>) }
                    self.filterCards("")
                }
            }
        } catch {
            print("Error")
        }
    }
    
    func filterCards(_ searchText: String) {
        self.cardData = self.rawCardData?
            .filter { card -> Bool in
                if searchText == "" {
                    return true
                }
                if let name = card.name {
                    let retVal = name.lowercased().contains(searchText.lowercased())
                    return retVal
                }
                return false
            }
            .sorted(by: { (card1, card2) -> Bool in
                if let name1 = card1.name, let name2 = card2.name {
                    return name1 <= name2
                }
                return false
            })
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = cardData?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cardCell") else {
            print("couldn't get a cell")
            return UITableViewCell()
        }
        guard let index = indexPath.last else {
            cell.textLabel?.text = "Error With Index"
            return cell
        }
        cell.textLabel?.text = self.cardData?[index].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = indexPath.last {
            performSegue(withIdentifier: "cardDetail", sender: self.cardData?[index])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CardViewController,
            let card = sender as? Card,
            let vc = segue.destination as? CardViewController
        {
            vc.card = card
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterCards(searchText)
    }
}

