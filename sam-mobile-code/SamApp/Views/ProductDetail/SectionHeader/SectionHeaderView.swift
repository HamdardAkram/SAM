//
//  SectionHeaderView.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var heading1Label: UILabel!
    @IBOutlet weak var heading2Label: UILabel!
    @IBOutlet weak var heading3Label: UILabel!
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setData(section: Int) {
        self.scanButton.isHidden = true
        if let sectionId = ProductSections(rawValue: section) {
            switch sectionId {
            case .shopthelook:
                self.scanButton.isHidden = false
                self.headerTitleLabel.text = "Shop the Look"
                self.heading1Label.text = "Sku"
                self.heading2Label.text = "Description"
                self.heading3Label.text = "Action"
            case .session:
                self.headerTitleLabel.text = "Session"
                self.heading1Label.text = "Scanned In"
                self.heading2Label.text = "Scanned Out"
                self.heading3Label.text = "Action"
            case .notes:
                self.heading2Label.textAlignment = .center
                self.headerTitleLabel.text = "Notes"
                self.heading1Label.text = "Date"
                self.heading2Label.text = "Written By"
                self.heading3Label.text = "Notes"
            }
        }
    }
    
    func setProductStatus() {
        self.topConstraint.constant = 16
        self.bottomConstraint.constant = 2
        self.heading2Label.textAlignment = .right
        self.scanButton.isHidden = true
        self.headerTitleLabel.isHidden = true
        
        self.heading1Label.text = "BARCODE"
        self.heading2Label.text = "SKU"
        self.heading3Label.text = "STATUS"
    }
}
