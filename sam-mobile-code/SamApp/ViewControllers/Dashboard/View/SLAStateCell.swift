//
//  SLAStateCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SLAStateCellDelegate: AnyObject {
    func showMonthPopup()
}

class SLAStateCell: UITableViewCell {

    @IBOutlet var stateCollectionView: UICollectionView!
    @IBOutlet var nameView: UIView! {
        didSet {
            nameView.clipsToBounds = true
            nameView.layer.borderWidth = 1.0
            nameView.layer.borderColor = UIColor.colorFromHex(rgbValue: 0x707070).cgColor
            nameView.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet var dropDownLabel: UILabel!
    
    weak var delegate: SLAStateCellDelegate?
    var slaStateData: ProductSLAData? {
        didSet {
            stateCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stateCollectionView.register(UINib(nibName: "SLAStateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SLAStateCollectionViewCell")
    }
    
    @IBAction func selectMonth(_ sender: UIButton) {
        delegate?.showMonthPopup()
    }
}

extension SLAStateCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SLAStateCollectionViewCell", for: indexPath) as! SLAStateCollectionViewCell
        cell.tag = indexPath.row
        if let data = slaStateData {
            cell.setData(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 330)
    }
}
