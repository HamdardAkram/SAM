//
//  ColorCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var colorImageView: UIImageView! {
        didSet {
            colorImageView.clipsToBounds = true
            colorImageView.layer.borderWidth = 1.0
            colorImageView.layer.borderColor = UIColor.gray.cgColor
            colorImageView.layer.cornerRadius = 2.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
