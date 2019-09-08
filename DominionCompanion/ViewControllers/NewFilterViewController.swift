//
//  NewFilterViewController.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 9/7/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class NewFilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    // MARK: Outlets
    @IBOutlet weak var propertyPicker: UIPickerView!
    @IBOutlet weak var operationPicker: UIPickerView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valuePicker: UIPickerView!

    var selectedProperty : CardProperty?
    var selectedOperation : FilterOperation?
    var selectedValue: String = ""
    
    var availableOperations: [FilterOperation] {
        get {
            guard let operations = self.selectedProperty?.inputType.availableOperations else { return [] }
            return operations
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedProperty = CardProperty.allCases[0]
        self.selectedOperation = self.selectedProperty?.inputType.availableOperations[0]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addFilter(_:)))
    }
    
    // MARK: Done Button Handler
    @objc func addFilter(_ sender: UIBarButtonItem) {
        guard let T = self.selectedProperty?.inputType,
            let property = self.selectedProperty,
            let operation = self.selectedOperation,
            let value = self.valueTextField.text
            else { return }
        let propFilter = T.init(property: property, value: value, operation: operation)
        let setFilter = SetFilter(value: 1, operation: .equal, propertyFilter: propFilter)
        FilterEngine.shared.addFilter(setFilter)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Picker Data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == propertyPicker {
            return CardData.shared.allAttributes.count
        } else {
            return self.availableOperations.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == propertyPicker {
            return CardData.shared.allAttributes[row].rawValue
        } else if pickerView == operationPicker{
            return self.availableOperations[row].rawValue
        } else if pickerView == valuePicker {
            
            return ""
        }
        return ""
    }
    
    // MARK: Picker Selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == propertyPicker {
            self.selectedProperty = CardData.shared.allAttributes[row]
            self.selectedOperation = self.availableOperations[0]
        } else if pickerView == operationPicker {
            self.selectedOperation = self.availableOperations[row]
        } else if pickerView == valuePicker {
            self.selectedValue = ""
        }
        self.operationPicker.reloadAllComponents()
        updateEntryView()
    }
    
    func updateEntryView() {
        guard let T = self.selectedProperty?.inputType else { return }
        if T == NumberFilter.self {
            self.valueTextField.placeholder = "Number"
        } else if T == StringFilter.self {
            self.valueTextField.placeholder = "String"
        } else if T == ListFilter.self {
            self.valueTextField.placeholder = "List"
        }
    }
    
    // MARK: TextFieldDelegate    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
