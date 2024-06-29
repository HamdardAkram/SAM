//
//  DashboardSummaryCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit

class DashboardSummaryCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var statisticsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let summaryCell = UINib.init(nibName: "SummaryCollectionViewCell", bundle: Bundle.main)
        statisticsCollectionView.register(summaryCell, forCellWithReuseIdentifier: "SummaryCollectionViewCell")
    }
    
    func setData() {
        nameLabel.text = "Hello Ayushi"
        welcomeLabel.text = "Welcome to your SAM4 dashboard"
        dateLabel.text = "Since: Jan 01 2024"
    }
}

extension DashboardSummaryCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCollectionViewCell", for: indexPath) as! SummaryCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20)/3, height: 127)
    }
}
