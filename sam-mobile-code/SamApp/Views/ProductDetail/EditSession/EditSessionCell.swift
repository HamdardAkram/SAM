//
//  EditSessionCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol EditSessionCellDelegate: class {
    func updateSessionDict(textField: UITextField, date: Double, forCell: EditSessionCell)
}

class EditSessionCell: UITableViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var byView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var byField: UITextField!
    
    weak var delegate: EditSessionCellDelegate?
    
    var selectedField: UITextField?
    var selecedDate: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.dateView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.2))
        self.byView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.2))
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        
        let toolBar = getToolBar()
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        self.dateField.inputView = EditSessionAdapter.datePicker
        self.dateField.inputAccessoryView = toolBar
    }

    func setData(data: [String: String]) {
        self.dateLabel.text = data["title"]
        guard let dateStr = data["date"] else {
            return
        }
        //self.dateField.tag = self.tag
        self.dateField.text = convertDate(date: dateStr)
        self.byField.text = data["by"]
    }
    
    @objc func doneTapped() {
    
        let strDate = AppDelegate.formatter.string(from: EditSessionAdapter.datePicker.date)
        self.selectedField?.text = strDate
        //self.selecedDate = datePicker.date
        self.selectedField?.resignFirstResponder()
    }

    @objc func cancelTapped() {
        self.selectedField?.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: Any) {

        let strDate = AppDelegate.formatter.string(from: EditSessionAdapter.datePicker.date)
        self.selectedField?.text = strDate
    }
}

fileprivate extension EditSessionCell {
    
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

extension EditSessionCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var dateNum = 0.0
        if textField.tag == 101 && textField.text?.isEmpty == false {
            dateNum = EditSessionAdapter.datePicker.date.timeIntervalSince1970
        }
        self.delegate?.updateSessionDict(textField: textField, date: dateNum, forCell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
