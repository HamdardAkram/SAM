//
//  SessionCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SessionCellDelegate: class {
    func showEditSession(sender: UIButton)
}

class SessionCell: UITableViewCell {

    @IBOutlet weak var scannedInLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: SessionCellDelegate?
    var maxSessionId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    func setData(session: ProductSession) {
        
        self.editButton.tag = self.tag
        var dateStr = ""
        if let dateNum = Double(session.scan_in_date.Value) {
            let date = Date(timeIntervalSince1970: dateNum)
            dateStr = AppDelegate.formatter.string(from: date)
        }
        self.editButton.isHidden = true
        guard let productPageActions = getProductPageActionItems() else {
            return
        }
        if session.product_session_id == maxSessionId && productPageActions.contains("edit_session") == true && session.scan_out_date.Value.isEmpty == true {
            self.editButton.isHidden = false
        }
        self.scannedInLabel.text = dateStr//session.scan_in_date.Value
        
        var scanOutDate = ""
        if let dateNum = Double(session.scan_out_date.Value) {
            let date = Date(timeIntervalSince1970: dateNum)
            scanOutDate = AppDelegate.formatter.string(from: date)
        }
        self.modelNameLabel.text = scanOutDate
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        self.delegate?.showEditSession(sender: sender)
    }
}
