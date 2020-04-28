//
//  DisclosuresViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 4/27/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class DisclosuresViewController: UIViewController {
    @IBOutlet weak var icons8Label: UILabel!
    @IBOutlet weak var rioGrandeLabel: UILabel!
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Disclosures"
        underlineAndAttachGesture(label: icons8Label, destination: "https://icons8.com")
        underlineAndAttachGesture(label: rioGrandeLabel, destination: "https://www.riograndegames.com/")
    }
    
    func underlineAndAttachGesture(label: UILabel, destination: String) {
        let text = NSMutableAttributedString(string: label.text ?? "")
        text.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.length))
        label.attributedText = text
        
        let tapGesture = LinkGesture(target: self, action: #selector(tappedLink(_:)))
        tapGesture.destination = destination
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
    }
    
    @objc func tappedLink(_ sender: LinkGesture) {
        guard let destination = sender.destination, let url = URL(string: destination) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

class LinkGesture: UITapGestureRecognizer {
    var destination: String?
}
