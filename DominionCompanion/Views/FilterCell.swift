//
//  FilterCell.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 11/3/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UITableViewCell {
    @IBOutlet weak var propertyPicker: UIPickerView!
    @IBOutlet weak var operationPicker: UIPickerView!
    @IBOutlet weak var valuePicker: UIPickerView!
    
    var property: CardProperty = .cost {
        didSet {
            delegate?.updateFilter(at: self.index, filter: self.currentFilter)
        }
    }
    var operation: FilterOperation = .greater {
        didSet {
            delegate?.updateFilter(at: self.index, filter: self.currentFilter)
        }
    }
    var value: String = "0" {
        didSet {
            delegate?.updateFilter(at: self.index, filter: self.currentFilter)
        }
    }
    var currentFilter: PropertyFilter {
        get {
            let T = self.property.inputType
            return T.init(property: property, value: value, operation: operation)
        }
    }
    
    var index: Int = 0
    var delegate: FilterCellDelegate?
    
    func setup(_ filter: PropertyFilter) {
        self.property = filter.property
        self.operation = filter.operation
        self.value = filter.stringValue
        propertyPicker.reloadAllComponents()
        if let propIndex = CardData.shared.allAttributes.index(of: property) {
            propertyPicker.selectRow(propIndex, inComponent: 0, animated: false)
        }
        operationPicker.reloadAllComponents()
        if let opIndex = property.inputType.availableOperations.index(of: operation) {
            operationPicker.selectRow(opIndex, inComponent: 0, animated: false)
        }
        valuePicker.reloadAllComponents()
        if let valueIndex = property.all.index(of: value) {
            valuePicker.selectRow(valueIndex, inComponent: 0, animated: false)
        }
    }
    
}

protocol FilterCellDelegate {
    func updateFilter(at index: Int, filter: PropertyFilter) -> Void
}

extension FilterCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case propertyPicker:
            return CardData.shared.allAttributes.count
        case operationPicker:
            return property.inputType.availableOperations.count
        case valuePicker:
            return property.all.count
        default:
            return 0
        }
    }
}

extension FilterCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case propertyPicker:
            return CardData.shared.allAttributes[row].rawValue
        case operationPicker:
            return property.inputType.availableOperations[row].rawValue
        case valuePicker:
            return property.all[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case propertyPicker:
            property = CardData.shared.allAttributes[row]
            operationPicker.reloadAllComponents()
            if let index = property.inputType.availableOperations.index(of: operation) {
                operationPicker.selectRow(index, inComponent: 0, animated: true)
            } else {
                operationPicker.selectRow(0, inComponent: 0, animated: true)
                operation = property.inputType.availableOperations[0]
            }
            valuePicker.reloadAllComponents()
            if let index = property.all.index(of: value) {
                valuePicker.selectRow(index, inComponent: 0, animated: true)
            } else {
                valuePicker.selectRow(0, inComponent: 0, animated: true)
                value = property.all[0]
            }
        case operationPicker:
            operation = property.inputType.availableOperations[row]
        case valuePicker:
            value = property.all[row]
        default:
            return
        }
    }
}
