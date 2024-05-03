//
//  NotesCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol NotesCellDelegate: class {
    func deleteButtonClicked(atCell: NotesCell)
}

class NotesCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    @IBOutlet weak var noteConstraint: NSLayoutConstraint!
    
    weak var delegate: NotesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.trashButton.isHidden = true
        self.noteConstraint.constant = 10.0
    }

    func setData(note: ProductNote) {
        guard let actions = getProductPageActionItems() else {
            return
        }
        if actions.contains("delete_note") {
            self.noteConstraint.constant = 40.0
            self.trashButton.isHidden = false
        }
        var dateStr = ""
        if let dateNum = Double(note.comment_date.Value) {
            let date = Date(timeIntervalSince1970: dateNum)
            dateStr = AppDelegate.formatter.string(from: date)
        }
        
        self.dateLabel.text = dateStr
        self.byLabel.text = note.comment_by
        self.notesLabel.text = note.comment
    }
    
    func setCopywriteData(copywriteData: ProductCopyright) {
        self.dateLabel.text = copywriteData.product_description
        self.notesLabel.text = copywriteData.inspiration
        self.byLabel.text = copywriteData.product_copywrite_by
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
        self.delegate?.deleteButtonClicked(atCell: self)
    }
}
