//
//  ViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 6/2/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    var card: Card?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.nameLabel?.text = self.card?.name
        self.textLabel?.text = self.card?.text
        do {
            if let name = self.card?.name,
                let path = Bundle.main.path(forResource: "cards/\(name)", ofType: "jpg") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let imageData = UIImage(data: data)
                self.imageView.image = imageData
            }
        } catch {
            
        }
    }
    
    @IBAction func close(sender: UIButton?) {
        self.dismiss(animated: true)
    }
}

