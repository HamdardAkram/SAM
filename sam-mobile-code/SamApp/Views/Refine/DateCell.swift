//
//  DateCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 31/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol DateCellDelegate: class {
    func checkDates(message: String)
}

class DateCell: UITableViewCell {
    
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    
    @IBOutlet weak var fromTextField: CustomTextField!
    @IBOutlet weak var toTextField: CustomTextField!
    
    weak var delegate: RefineTableViewCellDelegate?
    weak var dateDelegate: DateCellDelegate?
    
    var currentSection: RefineSection?
    var selectedField: CustomTextField?
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        datePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260)
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        self.fromTextField.inputView = datePicker
        self.toTextField.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        self.fromDateView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1))
        self.toDateView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1))
        
        self.fromTextField.attributedPlaceholder = NSAttributedString(string:"From Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4)])
        self.toTextField.attributedPlaceholder = NSAttributedString(string:"To Date", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4)])
    }

    func setData(sectionItem: RefineSection, indexPath: IndexPath) {
        currentSection = sectionItem
        self.fromTextField.indexPath = indexPath
        self.toTextField.indexPath = indexPath
        
        let toolBar = getToolBar()
        self.fromTextField.inputAccessoryView = toolBar
        self.toTextField.inputAccessoryView = toolBar
        
        guard let fromdate = sectionItem.fromDate else {
            return
        }
        self.fromTextField.text = AppDelegate.formatter.string(from: fromdate)
        
        guard let todate = sectionItem.toDate else {
            return
        }
        self.toTextField.text = AppDelegate.formatter.string(from: todate)
    }
    
    func saveDateInSection() {
        if self.selectedField?.tag == 100 {
            currentSection?.fromDate = datePicker.date
        }
        else {
            currentSection?.toDate = datePicker.date
        }
        let strDate = AppDelegate.formatter.string(from: datePicker.date)
        self.selectedField?.text = strDate
    }
    
    @objc func doneTapped() {
    
        saveDateInSection()
        self.selectedField?.resignFirstResponder()
    }

    @objc func cancelTapped() {
        self.selectedField?.text = ""
        self.selectedField?.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: Any) {

        saveDateInSection()
    }
}

fileprivate extension DateCell {
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
}

extension DateCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customField = textField as? CustomTextField {
            self.selectedField = customField
            self.delegate?.textFieldBeginEditing(textField: customField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let fromdate = currentSection?.fromDate {
            if let todate = currentSection?.toDate {
                if fromdate >  todate {
                    self.dateDelegate?.checkDates(message: "From date should be less than to date")
                    return
                }
                else {
                    if fromdate.months(from: todate) < -6 {
                        self.dateDelegate?.checkDates(message: "Date interval should not exceed 6 months")
                        return
                    }
                }
            }
        }
        if let customField = textField as? CustomTextField {
            self.delegate?.textFieldEndEditing(textField: customField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Date {
    
    func months(from date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: date)
        let date2 = calendar.startOfDay(for: self)
        let a = calendar.dateComponents([.month], from: date1, to: date2)
        return a.value(for: .month)!
    }
}
