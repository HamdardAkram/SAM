//
//  BarcodeTableViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 16/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class BarcodeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }
    
    func set(data: String) {
        self.titleLabel.text = data
    }
}
