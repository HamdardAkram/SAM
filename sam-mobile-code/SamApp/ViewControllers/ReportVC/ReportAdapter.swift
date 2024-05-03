//
//  ReportAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 17/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ReportAdapter: NSObject {

    fileprivate let reportCollectionView: UICollectionView
    fileprivate weak var reportView: ReportView?
    
    
    var dataSource:[UserReport] = [] {
        didSet {
            self.reportCollectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView, reportView: ReportView) {
        self.reportCollectionView = collectionView
        self.reportView = reportView
        
        super.init()
        
        //self.reportCollectionView.delegate = self
        
        self.registerCells()
        
        let user = getLoggedInUser()
        guard let reports = user?.reports else {
            return
        }
        self.dataSource = reports
        
    }
}

fileprivate extension ReportAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "HomeCollectionViewCell", bundle: Bundle.main)
        self.reportCollectionView.register(summaryCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
    }
}

extension ReportAdapter: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let report = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as! HomeCollectionViewCell
        cell.setReportData(report: report)
        
        return cell
        
    }
}

extension ReportAdapter: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: collectionView.frame.size.width, height: 101)
//
//    }
}

