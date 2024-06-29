//
//  StudioStateCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit

class StudioStateCell: UITableViewCell {

    @IBOutlet var colorCollectionView: UICollectionView!
    
    var studioStateData: StudioStateData? {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
}

extension StudioStateCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Total Product Scan In"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x969696)
            case 1:
                cell.titleLabel.text = "Total Product Shoot"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xEE7C00)
            case 2:
                cell.titleLabel.text = "Total Image Delivered"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 3:
                cell.titleLabel.text = "Total Product Delivered"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 4:
                cell.titleLabel.text = "Total Product Scan Out"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x007AFF)
            default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16)/2, height: 14)
    }
}
