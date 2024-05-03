//
//  SetProductStatusCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 06/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class SetProductStatusCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.indicatorView.makeRoundCorner(5)
    }

    func setData(product: ProductDetails) {
        self.barcodeLabel.text = product.data.first?.barcode
        self.skuLabel.text = product.data.first?.sku
    }
}
