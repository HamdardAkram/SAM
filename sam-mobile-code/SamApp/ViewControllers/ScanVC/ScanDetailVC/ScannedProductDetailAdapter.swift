//
//  ProductAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ScannedProductDetailAdapter: NSObject {
    
    fileprivate let productDetailCollectionView: UICollectionView
    fileprivate weak var productDetailView: ProductDetailView?
            
    var barcode: String = ""
    var dataSource:[[String: String]] = [] {
        didSet {
            self.productDetailCollectionView.reloadData()
        }
    }
        
    init(collectionView: UICollectionView, productDetailView: ProductDetailView) {
        self.productDetailCollectionView = collectionView
        self.productDetailView = productDetailView
        
        super.init()
        
        let columnLayout = ScannedProductDetailFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 0,
            minimumLineSpacing: 0,
            sectionInset: UIEdgeInsets.zero
        )
        
        self.productDetailCollectionView.collectionViewLayout = columnLayout
        self.productDetailCollectionView.contentInsetAdjustmentBehavior = .always
        self.productDetailCollectionView.delegate = self
        
        self.registerCells()
        self.registerHeaderView()
        
    }
}

fileprivate extension ScannedProductDetailAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "ProductDetailCollectionViewCell", bundle: Bundle.main)
        self.productDetailCollectionView.register(summaryCell, forCellWithReuseIdentifier: "ProductDetailCollectionViewCell")
        
    }
    
    func registerHeaderView() {
        let headerNib = UINib.init(nibName: "ProductDetailCollectionReusableView", bundle: Bundle.main)
        self.productDetailCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProductDetailCollectionReusableView")
    }
}

extension ScannedProductDetailAdapter: UICollectionViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductDetailCollectionViewCell.self), for: indexPath) as! ProductDetailCollectionViewCell
        
        let dict = dataSource[indexPath.item]
        cell.set(productData: dict)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: ProductDetailCollectionReusableView.self), for: indexPath as IndexPath) as! ProductDetailCollectionReusableView
                headerView.setData(barcode: self.barcode)
                return headerView
            default:
                print("end")
            }
        
        return UICollectionReusableView.init()
    }
}

extension ScannedProductDetailAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.productDetailView?.scanInDone()
    }
}

extension ScannedProductDetailAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
}
