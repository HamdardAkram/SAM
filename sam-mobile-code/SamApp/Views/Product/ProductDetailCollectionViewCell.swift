//
//  ProductDetailCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(productData: [String: String])  {
        self.titleLabel.text = productData["title"]
        self.valueLabel.text = productData["value"]
    }
}
