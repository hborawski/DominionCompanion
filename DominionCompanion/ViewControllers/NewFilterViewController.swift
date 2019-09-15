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
    @IBOutlet weak var cardOperationPicker: UIPickerView!
    @IBOutlet weak var cardValuePicker: UIPickerView!
    
    @IBOutlet weak var propertyPicker: UIPickerView!
    @IBOutlet weak var operationPicker: UIPickerView!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var valuePicker: UIPickerView!
    
    @IBOutlet weak var matchingCardLabel: UILabel!
    
    var existingFilterIndex: Int?

    var cardOperation: FilterOperation = .greaterOrEqual
    var cardValue: Int = 0
    
    var selectedProperty : CardProperty?
    var selectedOperation : FilterOperation?
    var selectedValue: String = ""
    
    var availableOperations: [FilterOperation] {
        get {
            guard let operations = self.selectedProperty?.inputType.availableOperations else { return [] }
            return operations
        }
    }
    
    var currentFilter: PropertyFilter? {
        get {
            guard let T = self.selectedProperty?.inputType,
                let property = self.selectedProperty,
                let operation = self.selectedOperation
                else { return nil }
            return T.init(property: property, value: self.selectedValue, operation: operation)
        }
    }
    
    var matchingCards: [Card] {
        get {
            guard let propFilter = self.currentFilter else { return [] }
            return CardData.shared.allCards.filter({ propFilter.match($0) })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedProperty = CardProperty.allCases[0]
        self.selectedOperation = self.selectedProperty?.inputType.availableOperations[0]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addFilter(_:)))
        
        self.valueTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If there is an index, we are editing
        guard let index = existingFilterIndex,
            let filter = FilterEngine.shared.getFilter(index)
            else { return }
        
        self.title = "Edit Filter"
        
        guard self.selectedValue == "" else { return }
        
        self.cardOperation = filter.operation
        self.cardValue = filter.value
        self.selectedProperty = filter.propertyFilter.property
        self.selectedOperation = filter.propertyFilter.operation
        self.selectedValue = filter.propertyFilter.stringValue
        
        self.cardValuePicker.selectRow(self.cardValue, inComponent: 0, animated: false)
        
        if let cardOperationIndex = NumberFilter.availableOperations.index(of: self.cardOperation) {
            self.cardOperationPicker.selectRow(cardOperationIndex, inComponent: 0, animated: false)
        }
        
        if let property = self.selectedProperty, let propertyIndex = CardData.shared.allAttributes.index(of: property) {
            self.propertyPicker.selectRow(propertyIndex, inComponent: 0, animated: false)
            if property.inputType == ListFilter.self, let valueIndex = property.all.index(of: self.selectedValue) {
                self.valuePicker.selectRow(valueIndex, inComponent: 0, animated: false)
            } else {
                self.valueTextField.text = self.selectedValue
            }
        }
        
        if let operation = self.selectedOperation, let operationIndex = self.availableOperations.index(of: operation) {
            self.operationPicker.selectRow(operationIndex, inComponent: 0, animated: false)
        }
        
        self.cardValuePicker.reloadAllComponents()
        self.cardOperationPicker.reloadAllComponents()
        self.propertyPicker.reloadAllComponents()
        self.operationPicker.reloadAllComponents()
        self.valuePicker.reloadAllComponents()
        
        self.updateEntryView()
    }
    
    // MARK: Done Button Handler
    @objc func addFilter(_ sender: UIBarButtonItem) {
        guard let propFilter = self.currentFilter else { return }
        let setFilter = SetFilter(value: cardValue, operation: cardOperation, propertyFilter: propFilter)
        if let index = self.existingFilterIndex {
            FilterEngine.shared.updateFilter(index, setFilter)
        } else {
            FilterEngine.shared.addFilter(setFilter)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Picker Data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == propertyPicker {
            return CardData.shared.allAttributes.count
        } else if pickerView == operationPicker {
            return self.availableOperations.count
        } else if pickerView == valuePicker {
            return self.selectedProperty?.all.count ?? 0
        } else if pickerView == cardOperationPicker {
            return NumberFilter.availableOperations.count
        } else if pickerView == cardValuePicker {
            return 11
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == propertyPicker {
            return CardData.shared.allAttributes[row].rawValue
        } else if pickerView == operationPicker{
            return self.availableOperations[row].rawValue
        } else if pickerView == valuePicker {
            return self.selectedProperty?.all[row]
        } else if pickerView == cardOperationPicker {
            return NumberFilter.availableOperations[row].rawValue
        } else if pickerView == cardValuePicker {
            return "\(row)"
        }
        return ""
    }
    
    // MARK: Picker Selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let updateSelectedValue = { (_ position: Int) -> Void in
            guard let all = self.selectedProperty?.all, all.count > 0 else { return }
            if let value = self.selectedProperty?.all[position] {
                self.selectedValue = value
            } else {
                self.selectedValue = ""
            }
        }
        let updateSelectedOperation = { () -> Void in
            self.operationPicker.reloadAllComponents()
            if let operation = self.selectedOperation, let operationIndex = self.availableOperations.index(of: operation) {
                self.operationPicker.selectRow(operationIndex, inComponent: 0, animated: false)
            } else {
                self.selectedOperation = self.availableOperations[0]
                self.operationPicker.selectRow(0, inComponent: 0, animated: false)
            }
        }
        if pickerView == propertyPicker {
            self.selectedProperty = CardData.shared.allAttributes[row]
            updateSelectedValue(0)
            updateSelectedOperation()
        } else if pickerView == operationPicker {
            self.selectedOperation = self.availableOperations[row]
            self.operationPicker.reloadAllComponents()
        } else if pickerView == valuePicker {
            updateSelectedValue(row)
        } else if pickerView == cardOperationPicker {
            self.cardOperation = NumberFilter.availableOperations[row]
        } else if pickerView == cardValuePicker {
            self.cardValue = row
        }
        self.valuePicker.reloadAllComponents()
        updateEntryView()
    }
    
    func updateEntryView() {
        guard let T = self.selectedProperty?.inputType,
            let count = self.selectedProperty?.all.count
            else { return }
        let animateAlphas = { (textView: Bool) -> Void in
            UIView.animate(withDuration: 0.2) {
                self.valueTextField.alpha = textView ? 1.0 : 0.0
                self.valuePicker.alpha = textView ? 0.0 : 1.0
            }
        }
        if T == NumberFilter.self && count == 0 {
            animateAlphas(true)
            self.valueTextField.placeholder = "0"
            self.valueTextField.keyboardType = .default
        } else if T == StringFilter.self {
            animateAlphas(true)
            self.valueTextField.placeholder = "Comparsion Text"
            self.valueTextField.keyboardType = .default
        } else if (T == ListFilter.self || (T == NumberFilter.self && count > 0)) {
            animateAlphas(false)
        } else if T == BooleanFilter.self {
            animateAlphas(false)
        }
        self.matchingCardLabel.text = "Matching Cards: \(self.matchingCards.count)"
    }
    
    // MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.selectedValue = text
        updateEntryView()
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.selectedValue = text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            identifier == "ViewMatchingCards",
            let destination = segue.destination as? CardsViewController
            else { return }
        destination.cardsToDisplay = self.matchingCards
    }
}
