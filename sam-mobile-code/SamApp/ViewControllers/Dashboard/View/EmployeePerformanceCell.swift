//
//  EmployeePerformanceCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit
import SimpleCharts

protocol EmployeePerformanceCellDelegate: AnyObject {
    func showEmployeePopup()
}

class EmployeePerformanceCell: UITableViewCell {

    @IBOutlet var colorCollectionView: UICollectionView!
    @IBOutlet var nameView: UIView! {
        didSet {
            nameView.clipsToBounds = true
            nameView.layer.borderWidth = 1.0
            nameView.layer.borderColor = UIColor.colorFromHex(rgbValue: 0x707070).cgColor
            nameView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet var dropDownLabel: UILabel!
    @IBOutlet var chart: GroupedBarChartView!
    @IBOutlet var containerView: UIView!
    
    var employeePerformanceData: EmployeeData? {
        didSet {
            setData()
        }
    }
    
    weak var delegate: EmployeePerformanceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
       
    }
    
    func setData() {
        
        let chart = GroupedBarChartView()
        chart.setGroupBarChartOptions([
              .showXAxis(true),
              .showYAxis(true),
              .showAvgLine(false),
              .showScrollIndicator(false),
              .scrollViewWidthInsets(21),
              .horizontalLineTintColor(.lightGray.withAlphaComponent(0.5)),
              .axisTintColor(.gray)]
              ,groupBarOptions: [
                  .barchartOptions([
                  .minBarWidth(36),
                  .cornerRounding(5),
                  .containerColor(.clear)]),
                    .groupSpacing(30)])

//        chart.yAxisFormatter = { (value: Double) in
//              return getShortedString(num: value)
//        }
        
        chart.entries = [
            GroupedEntryModel(entries: [
                BarEntryModel(value: 5214, color: .blue, label: "Facebook"),
                BarEntryModel(value: 4541, color: .blue, label: "Facebook")], label: "Facebook"),

            GroupedEntryModel(entries: [
                BarEntryModel(value: 653, color: .darkGray, label: "Github"),
                BarEntryModel(value: 123, color: .darkGray, label: "Github")], label: "Github"),
        ]
        chart.frame = CGRect(x: 10, y: 280, width: UIScreen.main.bounds.width - 20, height: 210)
        containerView.addSubview(chart)
    }
    
    @IBAction func selectEmployee(_ sender: UIButton) {
        delegate?.showEmployeePopup()
    }
}

extension EmployeePerformanceCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Model Photographer"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x969696)
            case 1:
                cell.titleLabel.text = "Mannequin Photographer"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xEE7C00)
            case 2:
                cell.titleLabel.text = "Still Photographer"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 3:
                cell.titleLabel.text = "Photo Ecom Photographer"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 4:
                cell.titleLabel.text = "Photo Ecom Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x007AFF)
            case 5:
                cell.titleLabel.text = "Copywriter Name"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x007AFF)
            case 6:
                cell.titleLabel.text = "Video Photographer"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16)/2, height: 14)
    }
}

