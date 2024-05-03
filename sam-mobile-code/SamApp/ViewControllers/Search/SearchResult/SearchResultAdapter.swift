//
//  SearchResultAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SearchResultAdapterDelegate: class {
    func didTapOnRow(indexPath: IndexPath)
    func fetchMoreProducts()
}

class SearchResultAdapter: NSObject {
    
    fileprivate let searchResultCollectionView: UICollectionView
    fileprivate weak var delegate: SearchResultAdapterDelegate?
    
    var footerView:LoadMoreFooterView?
    var isLoading:Bool = false
    
    var productDetails:ProductDetails? {
        didSet {
            self.searchResultCollectionView.reloadData()
            self.isLoading = false
        }
    }
        
    init(collectionView: UICollectionView, delegate: SearchResultAdapterDelegate) {
        self.searchResultCollectionView = collectionView
        self.delegate = delegate
        
        super.init()
        
        self.searchResultCollectionView.delegate = self
        
        self.registerCells()
        self.registerHeaderView()
        
    }
    
    func hideLoadMoreIndicator() {
        
        self.footerView?.stopAnimate()
        isLoading = true
        self.searchResultCollectionView.reloadData()
    }
}

fileprivate extension SearchResultAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "SearchResultCollectionViewCell", bundle: Bundle.main)
        self.searchResultCollectionView.register(summaryCell, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
    }
    
    func registerHeaderView() {
        let headerNib = UINib.init(nibName: "SearchResultHeaderCollectionView", bundle: Bundle.main)
        self.searchResultCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchResultHeaderCollectionView")
        
        let footerNib = UINib.init(nibName: "LoadMoreFooterView", bundle: Bundle.main)
        self.searchResultCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreFooterView")
    }
}

extension SearchResultAdapter: UICollectionViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productDetails?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchResultCollectionViewCell.self), for: indexPath) as! SearchResultCollectionViewCell
        if let product = self.productDetails?.data[indexPath.row] {
            cell.setData(product: product)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: SearchResultHeaderCollectionView.self), for: indexPath as IndexPath) as! SearchResultHeaderCollectionView
                headerView.setData(count: self.productDetails?.totalRecords ?? 0)
                return headerView
            case UICollectionView.elementKindSectionFooter:
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: LoadMoreFooterView.self), for: indexPath) as! LoadMoreFooterView
                self.footerView = aFooterView
                return aFooterView
            
            default:
                print("end")
            }
        
        return UICollectionReusableView.init()
    }
}

extension SearchResultAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didTapOnRow(indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let threshold = 10.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold = Float((diffHeight - frameHeight))/Float(threshold)
        triggerThreshold = min(triggerThreshold, 0.0)
        let pullRatio = min(abs(triggerThreshold), 1.0)
        
        if let footerview = self.footerView {
            footerview.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            if pullRatio >= 1 {
                footerview.animateFinal()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        let pullHeight  = abs(diffHeight - frameHeight)
        
        if pullHeight == 0.0 {
            if let footerview = self.footerView {
                if (footerview.isAnimatingFinal) {
                    self.isLoading = true
                    footerview.startAnimate()
                    self.delegate?.fetchMoreProducts()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
}

extension SearchResultAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 74)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
}
