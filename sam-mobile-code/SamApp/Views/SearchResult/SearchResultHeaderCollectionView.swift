//
//  SearchResultHeaderCollectionView.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class SearchResultHeaderCollectionView: UICollectionReusableView {

    @IBOutlet weak var headingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(count: Int) {
        
        let str = String(count) + " Items found"
        let countStr = String(count)
        let attributedQuote = NSMutableAttributedString(string: str)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.samRed(), range: NSRange(location: 0, length: countStr.count))

        self.headingLabel.attributedText = attributedQuote
    }
}
