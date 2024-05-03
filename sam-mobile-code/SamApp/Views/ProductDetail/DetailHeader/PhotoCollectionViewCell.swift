//
//  PhotoCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 20).isActive = true
        self.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }

}
