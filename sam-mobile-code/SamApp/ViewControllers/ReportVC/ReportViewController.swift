//
//  ReportViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 17/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ReportView: BaseView {

    func didTapOnRow(indexPath: IndexPath)
}

class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportCollectionView: UICollectionView!
    fileprivate var reportAdapter: ReportAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("REPORTS", comment: "")
        setupAdapter()
    }

}

fileprivate extension ReportViewController {
    func setupAdapter() {
        self.reportAdapter = ReportAdapter(collectionView: self.reportCollectionView, reportView: self)
        if let flowLayout = self.reportCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        self.reportCollectionView.dataSource = self.reportAdapter
       
    }
}

extension ReportViewController: ReportView {
    func didTapOnRow(indexPath: IndexPath) {
        
    }
}
