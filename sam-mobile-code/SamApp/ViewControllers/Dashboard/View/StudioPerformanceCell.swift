//
//  StudioPerformanceCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit

class StudioPerformanceCell: UITableViewCell {

    @IBOutlet var colorCollectionView: UICollectionView!
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var lineChart: LineChart!
    
    var studioPerformanceData: StudioPerformanceData? {
        didSet {
            setData()
            colorCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
        segmentControl.selectedSegmentIndex = 0
    }
    
    private func setData() {
        // simple arrays
        let data: [CGFloat] = (studioPerformanceData?.daily?.daily_scan_in_count ?? []).map { val in
            CGFloat(val)
        }
        let data2: [CGFloat] = (studioPerformanceData?.daily?.daily_photo_model_count ?? []).map { val in
            CGFloat(val)
        }
        let data3: [CGFloat] = (studioPerformanceData?.daily?.daily_photo_mannequin_count ?? []).map { val in
            CGFloat(val)
        }
        let data4: [CGFloat] = (studioPerformanceData?.daily?.daily_photo_still_count ?? []).map { val in
            CGFloat(val)
        }
        let data5: [CGFloat] = (studioPerformanceData?.daily?.daily_photo_ecom_count ?? []).map { val in
            CGFloat(val)
        }
        let data6: [CGFloat] = (studioPerformanceData?.daily?.daily_photo_image360_count ?? []).map { val in
            CGFloat(val)
        }
        let data7: [CGFloat] = (studioPerformanceData?.daily?.daily_copywrite_count ?? []).map { val in
            CGFloat(val)
        }
        let data8: [CGFloat] = (studioPerformanceData?.daily?.daily_video_shot_count ?? []).map { val in
            CGFloat(val)
        }
        // simple line with custom x axis labels
        let xLabels: [String] = studioPerformanceData?.daily?.daily_dates ?? []
        
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 1
        lineChart.y.grid.count = 50
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        lineChart.addLine(data3)
        lineChart.addLine(data4)
        lineChart.addLine(data5)
        lineChart.addLine(data6)
        lineChart.addLine(data7)
        lineChart.addLine(data8)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //show daily graph
        } else {
            //show monthly graph
        }
    }
}

extension StudioPerformanceCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Scan In Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x969696)
            case 1:
                cell.titleLabel.text = "Photo Model Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0xEE7C00)
            case 2:
                cell.titleLabel.text = "Photo Mannequin Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 3:
                cell.titleLabel.text = "Photo Still Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            case 4:
                cell.titleLabel.text = "Photo Ecom Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x007AFF)
            case 5:
                cell.titleLabel.text = "Photo Image360 Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x007AFF)
            case 6:
                cell.titleLabel.text = "Video Shot Count"
                cell.colorImageView.backgroundColor = UIColor.colorFromHex(rgbValue: 0x89A95E)
            default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16)/2, height: 14)
    }
}

extension StudioPerformanceCell: LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat]) {
        
    }
}
