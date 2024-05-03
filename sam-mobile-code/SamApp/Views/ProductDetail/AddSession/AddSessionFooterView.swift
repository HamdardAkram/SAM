//
//  AddSessionFooterView.swift
//  SamApp
//
//  Created by Muhammad Akram on 27/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AddSessionFooterViewDelegate: class {
    func addSessionClicked()
    func cancelClicked()
}

class AddSessionFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var sessionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var sessionFooterDelegate: AddSessionFooterViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sessionButton.makeRoundCorner(22)
        self.cancelButton.makeRoundCorner(22)
    }
    
    @IBAction func addSessionButtonClicked() {
        self.sessionFooterDelegate?.addSessionClicked()
    }

    @IBAction func cancelButtonClicked() {
        self.sessionFooterDelegate?.cancelClicked()
    }
}
