//
//  PreferencesFooterCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol PreferencesFooterCellDelegate: class {
    func apply()
}

class PreferencesFooterCell: UITableViewCell {

    @IBOutlet weak var applyButton: UIButton!
    
    weak var delegate:PreferencesFooterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyButton.clipsToBounds = true
        self.applyButton.layer.cornerRadius = 22.0
        
    }

    @IBAction func applyButtonClicked(_ sender: Any) {
        self.delegate?.apply()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
