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
    static func confirmation(title: String, confirmText: String, message: String, completion: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in alertController.dismiss(animated: true) } ))
        alertController.addAction(UIAlertAction(title: confirmText, style: .default, handler: { _ in completion() } ))
        return alertController
    }
    
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
    
    static func asSheet(title: String, actions: [SheetOption], message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(UIAlertAction(title: action.0, style: .default, handler: { (_) in
                action.1()
            }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in alertController.dismiss(animated: true) } ))
        return alertController
    }
}
typealias SheetOption = (String, () -> Void)

class AlertTextHandler: NSObject, UITextFieldDelegate {
    var text: String = ""
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.text = textField.text ?? ""
    }
}
