//
//  PreferencesTableViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import DLRadioButton

protocol PreferencesTableViewCellDelegate: class {
    func textFieldEndEditing(textField: UITextField)
    func textFieldBeginEditing(textField: UITextField)
    
    func getPickerView() -> ToolbarPickerView
}

class PreferencesTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldInputView: UIView!
    @IBOutlet weak var radioInputView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var yesButton: DLRadioButton!
    @IBOutlet weak var noButton: DLRadioButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var radioiViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDownIcon: UIImageView!
    
    weak var delegate: PreferencesTableViewCellDelegate?
    var selectedButton: DLRadioButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.fieldInputView.clipsToBounds = true
        self.fieldInputView.layer.cornerRadius = 3.0
        
        self.radioInputView.clipsToBounds = true
        self.radioInputView.layer.cornerRadius = 3.0
        
        self.fieldInputView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1))
        self.radioInputView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1))
    }

    @IBAction func radioButtonClicked(_ sender: DLRadioButton) {
        self.selectedButton?.isSelected = false
        self.yesButton.iconColor = UIColor.samGray()
        self.noButton.iconColor = UIColor.samGray()
        sender.iconColor = UIColor.samRed()
        sender.indicatorColor = UIColor.samRed()
        selectedButton = sender
        sender.isSelected = true
    }
    
    func set(data: String, indexPath: IndexPath) {
        
        self.fieldInputView?.isHidden = true
        self.radioInputView.isHidden = true
        
        self.inputTextField.delegate = self
        self.inputTextField.tag = indexPath.row
        
        self.yesButton.tag = indexPath.row
        self.noButton.tag = indexPath.row
        
        self.inputTextField.inputView = nil
        self.inputTextField.inputAccessoryView = nil
        self.dropDownIcon.isHidden = false
        
        switch indexPath.row {
            case 0:
                fallthrough
            case 1:
                self.fieldInputView?.isHidden = false
                self.inputTextField.inputView = self.delegate?.getPickerView()
                self.inputTextField.inputAccessoryView = self.delegate?.getPickerView().toolbar
                if let dict = UserDefaults.standard.value(forKey: USER_PREFERENCES) as? [String: Any] {
                    if let role = dict[ROLE] as? String {
                        if indexPath.row == 0 {
                            self.inputTextField.text = role
                        }
                    }
                    else {
                        self.inputTextField.text = data
                    }
                    if let role = dict[PHOTOGRAPHY_TYPE] as? String {
                        if indexPath.row == 1 {
                            self.inputTextField.text = role
                        }
                    }
                    else {
                        self.inputTextField.text = data
                    }
                }
                else {
                    self.inputTextField.text = data
                }
                
            case 2:
                self.fieldInputView?.isHidden = false
                self.dropDownIcon.isHidden = true
                self.inputTextField.attributedPlaceholder = NSAttributedString(string: "Stylist on set",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
                self.inputTextField.text = data
            case 3:
                self.fieldInputView?.isHidden = false
                self.dropDownIcon.isHidden = true
                self.inputTextField.attributedPlaceholder = NSAttributedString(string: "Model on set",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
                let user = getLoggedInUser()
                if user?.isModelManager ?? false {
                    self.dropDownIcon.isHidden = false
                    self.inputTextField.inputView = self.delegate?.getPickerView()
                    self.inputTextField.inputAccessoryView = self.delegate?.getPickerView().toolbar
                }
                self.inputTextField.text = data
            case 4:
                fallthrough
            case 5:
                self.radioInputView.isHidden = false
                self.nameLabel.text = data
                self.dropDownIcon.isHidden = true
            default: break
        }
    }
    
}

extension PreferencesTableViewCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldEndEditing(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
