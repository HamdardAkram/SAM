//
//  AddSessionCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AddSessionCellDelegate: class {
    func checkButtonClicked(button: UIButton)
}

class AddSessionCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: AddSessionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    func setData(data: [String: String]) {
        self.titleLabel.text = data["key"]
        self.checkButton.tag = self.tag
    }
    
    @IBAction func checkButtonClicked(_ sender: UIButton) {
        let imageName = sender.isSelected ? "unchecked_icon" : "checked_icon"
        self.checkButton.setImage(UIImage(named: imageName), for: .normal)
        self.checkButton.isSelected = !self.checkButton.isSelected
        self.delegate?.checkButtonClicked(button: sender)
    }
}
