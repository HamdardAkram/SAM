//
//  SearchResultCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func setData(product: ProductData) {
        self.titleLabel.text = product.barcode
        self.descLabel.text = product.description
        self.categoryLabel.text = product.category
    }
}
