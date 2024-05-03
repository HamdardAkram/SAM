//
//  ScanAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 16/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ScanAdapterDelegate: class {
    func didTapOnRow(indexPath: IndexPath)
}

class ScanAdapter: NSObject {

    fileprivate let scanCollectionView: UICollectionView
    fileprivate weak var delegate: ScanAdapterDelegate?
        
    var dataSource:[ProductDetails] = [] {
        didSet {
            self.scanCollectionView.reloadData()
        }
    }
        
    init(collectionView: UICollectionView, delegate: ScanAdapterDelegate) {
        self.scanCollectionView = collectionView
        self.delegate = delegate
        
        super.init()
        
        self.scanCollectionView.delegate = self
        
        self.registerCells()
        self.registerHeaderView()
    }
}

fileprivate extension ScanAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "ScanCollectionViewCell", bundle: Bundle.main)
        self.scanCollectionView.register(summaryCell, forCellWithReuseIdentifier: "ScanCollectionViewCell")
        
    }
    
    func registerHeaderView() {
        let headerNib = UINib.init(nibName: "ScanHeaderCollectionReusableView", bundle: Bundle.main)
        self.scanCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ScanHeaderCollectionReusableView")
    }
}

extension ScanAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScanCollectionViewCell.self), for: indexPath) as! ScanCollectionViewCell
        
        let product = dataSource[indexPath.row]
        cell.set(productDetail: product, indexPath: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: ScanHeaderCollectionReusableView.self), for: indexPath as IndexPath) as! ScanHeaderCollectionReusableView
                
                return headerView
            default:
                print("end")
            }
        
        return UICollectionReusableView.init()
    }
}

extension ScanAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.didTapOnRow(indexPath: indexPath)
        let product = self.dataSource[indexPath.row]
        product.toBeScanned = !product.toBeScanned
        self.scanCollectionView.reloadData()
    }
}

extension ScanAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 74)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}

extension ScanAdapter: ScanCollectionViewCellDelegate {
    
    func checkButtonCliced(sender: UIButton) {
        let product = self.dataSource[sender.tag]
        product.toBeScanned = !product.toBeScanned
        self.scanCollectionView.reloadData()
    }
}
