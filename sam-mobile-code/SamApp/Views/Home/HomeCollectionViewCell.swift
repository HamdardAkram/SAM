//
//  HomeCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 24).isActive = true
        
        containerView.makeRoundCorner(10)
    }
    
    func set(dict: [String: String]) {
        self.titleLabel.text = dict["title"]
        self.descLabel.text = dict["description"]
        self.thumbnailView.image = UIImage(named: dict["icon"] ?? "")
    }
    
    func setReportData(report: UserReport) {
        self.titleLabel.text = report.title
        self.descLabel.text = report.description
        self.thumbnailView.image = UIImage(named: "doc_icon")
    }
}
