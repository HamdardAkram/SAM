//
//  SectionFooterView.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SectionFooterViewDelegate: class {
    
    func didTapOnAddButton(sender: UIButton)
    func didTapOnViewMoreButton(sender: UIButton)
}

class SectionFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var viewMoreButton: UIButton!
    weak var delegate: SectionFooterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addButton.clipsToBounds = true
        self.addButton.layer.cornerRadius = 16.0
        self.addButton.isHidden = false
    }

    func setData(section: Int, product: ProductData, showViewMore: [Int: Bool]) {

        guard let productPageActions = getProductPageActionItems() else {
            return
        }
        
        self.addButton.tag = section
        self.viewMoreButton.tag = section
        
        self.viewMoreButton.isHidden = true
        if let sectionId = ProductSections(rawValue: section) {
            switch sectionId {
            case .shopthelook:
                self.addButton.setTitle("+Add new", for: .normal)
                if product.outfit.count > OUTFIT_COUNT && showViewMore[section] == false {
                    self.viewMoreButton.isHidden = false
                    self.viewMoreButton.setTitle("View more (" + "\(product.outfit.count - OUTFIT_COUNT))" , for: .normal)
                }
            case .session:
                if productPageActions.contains("add_session") == false {
                    self.addButton.isHidden = true
                }
                self.addButton.setTitle("+Add session", for: .normal)
                if product.sessions.count > SESSION_COUNT && showViewMore[section] == false {
                    self.viewMoreButton.isHidden = false
                    self.viewMoreButton.setTitle("View more (" + "\(product.sessions.count - SESSION_COUNT))", for: .normal)
                }
            case .notes:
                if productPageActions.contains("add_note") == false {
                    self.addButton.isHidden = true
                }
                self.addButton.setTitle("+Add note", for: .normal)
                //self.viewMoreButton.isHidden = false
                self.viewMoreButton.setTitle("View more (2)", for: .normal)
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        self.delegate?.didTapOnAddButton(sender: sender)
    }
    
    @IBAction func viewMoreButtonClicked(_ sender: UIButton) {
        self.delegate?.didTapOnViewMoreButton(sender: sender)
    }
}
