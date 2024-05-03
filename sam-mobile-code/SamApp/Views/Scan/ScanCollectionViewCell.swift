//
//  ScanCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ScanCollectionViewCellDelegate: class {
    
    func checkButtonCliced(sender: UIButton)
}

class ScanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    
    weak var delegate: ScanCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionButton.clipsToBounds = true
        self.selectionButton.layer.cornerRadius = 2.0
        self.selectionButton.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.5))
    }
    
    func set(productDetail: ProductDetails, indexPath: IndexPath) {
        guard let product = productDetail.data.first else {
            return
        }
        self.selectionButton.tag = indexPath.row
        self.selectionButton.addTarget(self, action: #selector(onCheckButtonClick), for: .touchUpInside)
        self.selectionButton.setBackgroundImage(nil, for: .normal)
        if productDetail.toBeScanned == true {
            self.selectionButton.setBackgroundImage(UIImage(named: "checked_icon"), for: .normal)
        }
        self.titleLabel.text = product.barcode
        self.descLabel.text = product._id
        self.categoryLabel.text = product.category
    }

    @objc func onCheckButtonClick(_ sender: UIButton) {
        self.delegate?.checkButtonCliced(sender: sender)
    }
}
