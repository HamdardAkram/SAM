//
//  EditSessionHeaderView.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol EditSessionHeaderViewDelegate: class {
    func billableButtonClicked(button: UIButton)
    func slaButtonClicked(button: UIButton)
    
    func getPickerView() -> ToolbarPickerView
    
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
}

class EditSessionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var reasonInputField: CustomTextField!
    
    @IBOutlet weak var sessionView: UIView!
    
    @IBOutlet weak var billableButton: UIButton!
    @IBOutlet weak var slaButton: UIButton!
    
    @IBOutlet weak var sessionIdLabel: UILabel!
    @IBOutlet weak var sessionIdField: UITextField!
    
    weak var headerDelegate: EditSessionHeaderViewDelegate?
    
    var sessionObject: ProductSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.reasonView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.2))
        self.sessionView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.2))
    }

    func setData(session: ProductSession?) {
        if session?.billable.Value == "1" {
            self.billableButton.isSelected = true
        }
        if session?.sla.Value == "1" {
            self.slaButton.isSelected = true
        }
        self.reasonInputField.inputView = self.headerDelegate?.getPickerView()
        self.reasonInputField.inputAccessoryView = self.headerDelegate?.getPickerView().toolbar
        self.reasonInputField.text = reasonAsPerWrongCode(code: session?.wrong_code ?? "0")
        
        self.sessionIdLabel.text = "Session ID"
        self.sessionIdField.text = String(session?.product_session_id ?? 0)
    }
    
    func reasonAsPerWrongCode(code: String) -> String {
        switch code {
            case "0":
                return "Select Reason"
            case "1":
                return DAMAGED_PRODUCTS
            case "2":
                return WRONG_SIZE
            case "3":
                return PRODUCTS_TO_RETURN
            case "4":
                return HELD_FOR_MODEL
            case "5":
                return WRONG_COLOR
            default:
                return ""
        }
    }
    
    @IBAction func billableButtonClicked() {
        let imageName = self.billableButton.isSelected ? "unchecked_icon" : "checked_icon"
        self.billableButton.setImage(UIImage(named: imageName), for: .normal)
        self.billableButton.isSelected = !self.billableButton.isSelected
        self.headerDelegate?.billableButtonClicked(button: self.billableButton)
    }
    
    @IBAction func slaButtonClicked() {
        let imageName = self.slaButton.isSelected ? "unchecked_icon" : "checked_icon"
        self.slaButton.setImage(UIImage(named: imageName), for: .normal)
        self.slaButton.isSelected = !self.slaButton.isSelected
        self.headerDelegate?.slaButtonClicked(button: self.slaButton)
    }
}

extension EditSessionHeaderView: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customField = textField as? CustomTextField {
            //self.selectedField = customField
            self.headerDelegate?.textFieldBeginEditing(textField: customField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let customField = textField as? CustomTextField {
            self.headerDelegate?.textFieldEndEditing(textField: customField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
