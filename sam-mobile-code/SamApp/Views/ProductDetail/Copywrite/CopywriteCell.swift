//
//  CopywriteCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 26/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class CopywriteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    @IBOutlet weak var inputFieldView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.inputFieldView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.16))
    }

    func setData(dict: [String: String]) {
        self.titleLabel.text = dict["title"]
        self.valueField.text = dict["value"]
    }
    
}
