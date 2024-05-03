//
//  ShopTheLookCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ShopTheLookCellDelegate: class {
    func deleteButtonClicked(atCell: ShopTheLookCell)
}

class ShopTheLookCell: UITableViewCell {

    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    //@IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    weak var delegate: ShopTheLookCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func setData(outfit: ProductOutFit) {
        self.skuLabel.text = outfit.sku_long
        self.descLabel.text = outfit.description
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.delegate?.deleteButtonClicked(atCell: self)
    }
}
