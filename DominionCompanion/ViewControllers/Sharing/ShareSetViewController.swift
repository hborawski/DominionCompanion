//
//  ShareSetViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 3/13/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class ShareSetViewController: UIViewController {
    @IBOutlet weak var qrImageView: UIImageView!
    
    var cards: [Card] = []
    override func viewDidLoad() {
        guard let image = generateQRCode(from: cards.map({$0.name})) else { return }
        qrImageView.image = image
    }
    
    func generateQRCode(from string: [String]) -> UIImage? {
        guard let data = try? JSONEncoder().encode(string) else { return nil }

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
    
    @IBAction func closeModalView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
