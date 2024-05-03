//
//  DetailHeaderView.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SDWebImage

protocol DetailHeaderViewDelegate: AnyObject {
    func infoRowTapped()
    func didTapOnItem(indexPath: IndexPath)
}

class DetailHeaderView: UIView {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    weak var headerDelegate: DetailHeaderViewDelegate?

    var productData: ProductData? {
        didSet {
            self.photoCollectionView.reloadData()
        }
    }
    
    let padding: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        
        SDImageCache.shared.config.shouldCacheImagesInMemory = false

        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoRowClicked)))
        
        registerCells()
        
        if let fl = photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            fl.scrollDirection = .horizontal
            fl.estimatedItemSize = CGSize(width: 1, height: 1)
        }

    }
    
    @objc func infoRowClicked() {
        self.headerDelegate?.infoRowTapped()
    }
}

fileprivate extension DetailHeaderView {
    
    func registerCells() {
        
        
        let photoNib = UINib.init(nibName: "PhotoCollectionViewCell", bundle: Bundle.main)
        self.photoCollectionView.register(photoNib, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
}

extension DetailHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productData?.images.count ?? 0 > 0 {
            collectionHeightConstraint.constant = 350
        }
        else {
            collectionHeightConstraint.constant = 0
        }
        
        return productData?.images.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as! PhotoCollectionViewCell
        //cell.imageView.contentMode = .scaleAspectFill
                
        let imageObj = productData?.images[indexPath.item]
        let imageName = imageObj?.image_name ?? ""
        cell.imageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "scan_icon"))
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        var size = CGSize(width: collectionView.frame.size.width/2, height: 180)
//        
////        let collectionWidth = collectionView.frame.size.width
////        let collectionHeight = collectionView.frame.size.height
////        
////        let remainder = indexPath.row % 4
////        switch remainder {
////        case 0:
////            let width = (collectionWidth - padding)/2
////            let height = collectionHeight
////            size = CGSize(width: width, height: height)
////        case 1:
////            let width = (collectionWidth - padding)/2
////            let height = (productData?.images.count ?? 0 > 2) ? (collectionHeight - padding)/2 : collectionHeight
////            size = CGSize(width: width, height: height)
////        case 2:
////            let width = (collectionWidth - padding)/4
////            let height = (collectionHeight - padding) / 2
////            size = CGSize(width: width, height: height)
////        case 3:
////            let width = (collectionWidth - padding)/4
////            let height = (collectionHeight - padding)/2
////            size = CGSize(width: width, height: height)
////        default:
////            size = CGSize(width: collectionWidth, height: collectionHeight)
////        }
//        return size
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.headerDelegate?.didTapOnItem(indexPath: indexPath)
    }
}
