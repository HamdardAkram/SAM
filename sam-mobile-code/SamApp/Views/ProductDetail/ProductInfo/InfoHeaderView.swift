//
//  InfoHeaderView.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class InfoHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var isSampleButton: UIButton!
    @IBOutlet var isLuxuryButton: UIButton!
    @IBOutlet var isMannequinButton: UIButton!
    @IBOutlet var isExtraDetailButton: UIButton!
    
    
    var productInfo: ProductData? {
        didSet {
            isSampleButton.setImage(UIImage(named: "unchecked_icon"), for: .normal)
            isLuxuryButton.setImage(UIImage(named: "unchecked_icon"), for: .normal)
            isMannequinButton.setImage(UIImage(named: "unchecked_icon"), for: .normal)
            isExtraDetailButton.setImage(UIImage(named: "unchecked_icon"), for: .normal)
            if productInfo?.is_sample ?? 0 > 0 {
                isSampleButton.setImage(UIImage(named: "checked_icon"), for: .normal)
            }
            if productInfo?.is_luxury ?? 0 > 0 {
                isLuxuryButton.setImage(UIImage(named: "checked_icon"), for: .normal)
            }
            if productInfo?.requires_mannequin ?? 0 > 0 {
                isMannequinButton.setImage(UIImage(named: "checked_icon"), for: .normal)
            }
            if productInfo?.extra_details ?? 0 > 0 {
                isExtraDetailButton.setImage(UIImage(named: "checked_icon"), for: .normal)
            }
        }
    }

}
