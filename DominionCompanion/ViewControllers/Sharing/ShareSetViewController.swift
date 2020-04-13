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
    
    var set = ShareableSet(cards: [], events: [], landmarks: [], projects: [])
    override func viewDidLoad() {
        guard let image = generateQRCode(from: set) else { return }
        qrImageView.image = image
    }
    
    func generateQRCode(from set: ShareableSet) -> UIImage? {
        guard
            let data = try? JSONEncoder().encode(set),
            let filter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }
        filter.setValue(data, forKey: "inputMessage")

        guard
            let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 3, y: 3))
        else { return nil }
        
        return UIImage(ciImage: output)
    }
    
    @IBAction func closeModalView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
