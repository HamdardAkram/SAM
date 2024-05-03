//
//  refineTableViewCell.swift
//  SamApp
//
//  Created by Akram on 16/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol RefineTableViewCellDelegate: class {
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
    
    func getPickerView() -> ToolbarPickerView
    func scanButtonClicked(index: Int)
}

class CustomTextField: UITextField {
    var indexPath: IndexPath?
    var identifier: String?
}

class RefineTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    var selectedField: CustomTextField?
    
    weak var delegate: RefineTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.titleTextField.delegate = self
        self.titleTextField.textColor = UIColor.white
        self.titleTextField.setFontMetrics(font: UIFont.thirteenHelveticaNeue())
        
        self.containerView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1))
    }
    
    @IBAction func dateButtonClicked(_ sender: UIButton) {
        
    }
    
    func setData(sectionItem: RefineSection, indexPath: IndexPath) {
        
        self.titleTextField.text = ""
        
        self.titleTextField.inputView = nil
        self.titleTextField.inputAccessoryView = nil
        
        self.titleTextField.indexPath = indexPath
        self.titleTextField.tag = indexPath.row
        let item = sectionItem.items[indexPath.row]
        self.scanButton.isHidden = true
        if item.itemName == "Barcode" {
            self.scanButton.isHidden = false
            self.scanButton.tag = indexPath.row
            self.scanButton.addTarget(self, action: #selector(onScanButtonClicked(_ : )), for: .touchUpInside)
        }
        self.titleTextField.text = item.itemValue
        self.titleTextField.attributedPlaceholder = NSAttributedString(string:item.itemName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4)])
        if indexPath.section == 1 && indexPath.row == 4 {
            self.titleTextField.tag = indexPath.row
            self.titleTextField.inputView = self.delegate?.getPickerView()
            self.titleTextField.inputAccessoryView = self.delegate?.getPickerView().toolbar
        }
    }
    
    @objc func onScanButtonClicked(_ sender: UIButton) {
        self.delegate?.scanButtonClicked(index: sender.tag)
    }
}

extension RefineTableViewCell: UITextFieldDelegate {
    
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
        if let customField = textField as? CustomTextField {
            self.delegate?.textFieldEndEditing(textField: customField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
