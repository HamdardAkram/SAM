//
//  HomeAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class HomeAdapter: NSObject {
    
    fileprivate let homeCollectionView: UICollectionView
    fileprivate weak var homeView: HomeView?
    
    var dataSource:[[String: String]] = [["title": "Reports", "description": "View or download scanIn/out, search, session and copywright reports", "icon": "report"], ["title": "Products & Samples", "description": "Search for products by their properties and production status", "icon": "product"], ["title": "Manifests & Picklists", "description": "Import a concession manifest file to add products to SAM", "icon": "import"]] {
        didSet {
            self.homeCollectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView, homeView: HomeView) {
        self.homeCollectionView = collectionView
        self.homeView = homeView
        
        super.init()
        
        self.homeCollectionView.delegate = self
        
        self.registerCells()
        self.registerHeaderView()
        
        let user = getLoggedInUser()
        let userRights = user?.user_rights[0]
        guard let menuItems = userRights?.menu_items else {
            return
        }
        if menuItems.contains("help") {
            self.dataSource.append(["title": "Help", "description": "Tap here to see the instructions", "icon": "product"])
        }
        if menuItems.contains("style_guides") {
            self.dataSource.append(["title": "Style Guide", "description": "Tap here to see the style guide instructions", "icon": "product"])
        }
    }
    
    @objc func onSearchClick() {
        self.homeView?.moveToSearchScreen()
    }
}

fileprivate extension HomeAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "HomeCollectionViewCell", bundle: Bundle.main)
        self.homeCollectionView.register(summaryCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
    }
    
    func registerHeaderView() {
        let headerNib = UINib.init(nibName: "HomeHeaderCollectionReusableView", bundle: Bundle.main)
        self.homeCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderCollectionReusableView")
    }
}

extension HomeAdapter: UICollectionViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as! HomeCollectionViewCell
        cell.set(dict: dict)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HomeHeaderCollectionReusableView.self), for: indexPath as IndexPath) as! HomeHeaderCollectionReusableView
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSearchClick))
                headerView.searchView.addGestureRecognizer(tapGesture)
                return headerView
            default:
                print("end")
            }
        
        return UICollectionReusableView.init()
    }
}

extension HomeAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homeView?.didTapOnRow(indexPath: indexPath)
    }
}

