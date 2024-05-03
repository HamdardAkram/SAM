//
//  ProfileTableViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(data: String) {
        self.titleLabel.text = data
    }
}
