//
//  AlertBuilder.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 5/12/20.
//  Copyright © 2020 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class AlertBuilder {
    static func withTextField(title: String, message: String = "", defaultText: String = "Save", completion: @escaping (String) -> Void = {_ in}) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let textHandler = AlertTextHandler()
        alertController.addTextField(configurationHandler: { textField in
            textField.delegate = textHandler
            textField.placeholder = "Name..."
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in alertController.dismiss(animated: true) } ))
        alertController.addAction(UIAlertAction(title: defaultText, style: .default, handler: { _ in completion(textHandler.text) } ))
        return alertController
    }
}

class AlertTextHandler: NSObject, UITextFieldDelegate {
    var text: String = ""
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.text = textField.text ?? ""
    }
}
