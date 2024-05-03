//
//  AccountDetailCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AccountDetailCellDelegate: class {
    func updateAccountDetail(textField: UITextField, forCell: AccountDetailCell)
    func textFieldBeginEditing(textField: UITextField)
}

class AccountDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    
    weak var delegate: AccountDetailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4))
        self.fieldView.backgroundColor = UIColor.black
        //self.leadingConstraint.constant = 16
    }
    
    func set(data: [String: String]) {
        self.editTextField.tag = self.tag
        self.editTextField.isUserInteractionEnabled = self.tag > 1 ? true : false
        self.titleLabel.text = data["title"]
        let user = getLoggedInUser()
        if self.tag == 0 {
            self.editTextField.text = user?.data?.email
        }
        else if self.tag == 1 {
            self.editTextField.text = user?.data?.full_name
        }
        else {
            self.editTextField.text = data["value"]
        }
    }
}

extension AccountDetailCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updateAccountDetail(textField: textField, forCell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) as UIResponder?

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return true
    }
}
