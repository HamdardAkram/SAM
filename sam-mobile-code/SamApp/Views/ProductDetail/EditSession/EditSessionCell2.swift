//
//  EditSessionCell2.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol EditSessionCell2Delegate: class {
    func updateSessionDictForSectionTwo(textField: UITextField, forCell: EditSessionCell2)
    func textFieldBeginEditing(textField: UITextField)
    func showPickerView() -> ToolbarPickerView
}

class EditSessionCell2: UITableViewCell {

    @IBOutlet weak var styleInputView: UIView!
    @IBOutlet weak var styleInputTextField: UITextField!
    @IBOutlet weak var styleTitleLabel: UILabel!
    @IBOutlet weak var dropIcon: UIImageView!
    
    weak var delegate: EditSessionCell2Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleInputView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.2))
    }

    func setData(data: [String: String], session: ProductSession?) {
        self.styleTitleLabel.text = data["title"]
        self.styleInputTextField.text = data["value"]
        self.styleInputTextField.tag = self.tag
        if self.tag == 4 && session?.is_model_manager == "1" {
            self.styleInputTextField.inputView = self.delegate?.showPickerView()
            self.styleInputTextField.inputAccessoryView = self.delegate?.showPickerView().toolbar
            self.dropIcon.isHidden = false
        }
        else {
            self.dropIcon.isHidden = true
            self.styleInputTextField.inputView = nil
            self.styleInputTextField.inputAccessoryView = nil
        }
    }
}

extension EditSessionCell2: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.selectedField = textField
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updateSessionDictForSectionTwo(textField: textField, forCell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
