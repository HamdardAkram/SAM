//
//  ProductInfoCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductInfoCellDelegate: class {
    func updateProductInfo(textField: CustomTextField, forCell: ProductInfoCell)
    func textFieldBeginEditing(textField: CustomTextField)
}


class ProductInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editTextField: CustomTextField!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    weak var delegate: ProductInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func getKeyValue(key: String, data: ProductData) -> String {
        if key.contains("date") {
            if let dateNum = Double(data.productInfo[key]?.Value ?? "") {
                let date = Date(timeIntervalSince1970: dateNum)
                return AppDelegate.formatter.string(from: date)
            }
        }
        return data.productInfo[key]?.Value ?? ""
    }
    
    func setFieldProperties(borderColor: UIColor, backgroundColor: UIColor, constraint: CGFloat, enabled: Bool) {
        self.fieldView.makeBorder(1.0, color: borderColor)
        self.fieldView.backgroundColor = backgroundColor
        self.leadingConstraint.constant = constraint
        self.editTextField.isUserInteractionEnabled = enabled
    }
    
    func setData(data: [String: String], productData: ProductData, editMode: Bool) {
        self.titleLabel.text = data["title"]
        
        if let key = data["title"] {
            let originalKey = key.lowercased().replacingOccurrences(of: " ", with: "_")
            self.editTextField.text = getKeyValue(key: originalKey, data: productData)
            self.editTextField.identifier = originalKey
        }
        if editMode == true {
            if self.editTextField.identifier != "combicode" && self.editTextField.identifier != "barcode" && self.editTextField.identifier != "_id" {
                setFieldProperties(borderColor: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4), backgroundColor: UIColor.black, constraint: 16, enabled: true)
            }
            else {
                setFieldProperties(borderColor: UIColor.samBlack(), backgroundColor: UIColor.samBlack(), constraint: 0, enabled: false)
            }
        }
        else {
            setFieldProperties(borderColor: UIColor.samBlack(), backgroundColor: UIColor.samBlack(), constraint: 0, enabled: false)
        }
    }
    
}

extension ProductInfoCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let customField = textField as? CustomTextField {
            self.delegate?.textFieldBeginEditing(textField: customField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let customField = textField as? CustomTextField {
            self.delegate?.updateProductInfo(textField: customField, forCell: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
