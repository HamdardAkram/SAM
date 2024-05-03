//
//  DetailFooterView.swift
//  SamApp
//
//  Created by Muhammad Akram on 26/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol DetailFooterViewDelegate: class {
    func footerTapped()
}


class DetailFooterView: UITableViewHeaderFooterView {

    weak var footerDelegate: DetailFooterViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(footerClicked)))
        
    }
    @objc func footerClicked() {
        self.footerDelegate?.footerTapped()
    }
}
