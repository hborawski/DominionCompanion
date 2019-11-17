//
//  RangeCell.swift
//  DominionCompanion
//
//  Created by Harris Borawski on 11/3/19.
//  Copyright © 2019 Harris Borawski. All rights reserved.
//

import Foundation
import UIKit

class RangeCell: UITableViewCell {
    @IBOutlet weak var operationPicker: UIPickerView!
    @IBOutlet weak var valuePicker: UIPickerView!
    var delegate: RangeDelegate?
    

    func setup(operation: FilterOperation, value: Int) {
        operationPicker.reloadAllComponents()
        valuePicker.reloadAllComponents()
        if let opIndex = RuleType.number.availableOperations.index(of: operation) {
            operationPicker.selectRow(opIndex, inComponent: 0, animated: false)
        }
        valuePicker.selectRow(value, inComponent: 0, animated: false)
    }
}

protocol RangeDelegate {
    func setOperation(_ operation: FilterOperation) -> Void
    func setValue(_ value: Int) -> Void
    func setRange(lower: Int, upper: Int) -> Void
}

extension RangeCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case operationPicker:
            delegate?.setOperation(RuleType.number.availableOperations[row])
        case valuePicker:
            delegate?.setValue(row)
        default:
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case operationPicker:
            return RuleType.number.availableOperations[row].rawValue
        case valuePicker:
            return "\(row)"
        default:
            return ""
        }
    }
}

extension RangeCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case operationPicker:
            return RuleType.number.availableOperations.count
        case valuePicker:
            return 11
        default:
            return 0
        }
    }
}
