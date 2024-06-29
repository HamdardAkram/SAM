//
//  SLAStateCollectionViewCell.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit
import PieCharts

class SLAStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet var chartView: PieChart!
    var textLayerSettings = PiePlainTextLayerSettings()
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var colorBox1: UIImageView!
    @IBOutlet var colorBox2: UIImageView!
    @IBOutlet var colorBox3: UIImageView!
    
    @IBOutlet var stackViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: ProductSLAData) {
        var models: [PieSliceModel] = []
        stackViewHeight.constant = 60
        label3.isHidden = true
        colorBox3.isHidden = true
        switch self.tag {
            case 0:
                label1.text = "Product In SLA"
                label2.text = "Product Out SLA"
                colorBox1.backgroundColor = UIColor.colorFromHex(rgbValue: 0x64A3D7)
                colorBox2.backgroundColor = UIColor.colorFromHex(rgbValue: 0x7853D2)
                var color = UIColor.colorFromHex(rgbValue: 0x64A3D7)
                for value in (data.product_SLA ?? []) {
                    models.append(PieSliceModel(value: Double(value), color: color))
                    color = UIColor.colorFromHex(rgbValue: 0x7853D2)
                }
            case 1:
                label3.isHidden = false
                colorBox3.isHidden = false
                label1.text = "Products waiting for shoot"
                label2.text = "Products waiting for images"
                label3.text = "Total products shoot"
                colorBox1.backgroundColor = UIColor.colorFromHex(rgbValue: 0x64A3D7)
                colorBox2.backgroundColor = UIColor.colorFromHex(rgbValue: 0x7853D2)
                colorBox3.backgroundColor = UIColor.colorFromHex(rgbValue: 0x81B3DD)
                stackViewHeight.constant = 80
                var color = UIColor.colorFromHex(rgbValue: 0x64A3D7)
                var index: Int = 0
                for value in data.product_shoot_data ?? [] {
                    models.append(PieSliceModel(value: Double(value), color: color))
                    index += 1
                    if index == 1 {
                        color = UIColor.colorFromHex(rgbValue: 0x64A3D7)
                    } else {
                        color = UIColor.colorFromHex(rgbValue: 0x81B3DD)
                    }
                }
            case 2:
                label1.text = "Product Waiting For Shoot"
                label2.text = "Total Products Shoot"
                colorBox1.backgroundColor = UIColor.colorFromHex(rgbValue: 0xE1D79C)
                colorBox2.backgroundColor = UIColor.colorFromHex(rgbValue: 0xD49C73)
                var color = UIColor.colorFromHex(rgbValue: 0xE1D79C)
                for value in data.product_production_data ?? [] {
                    models.append(PieSliceModel(value: Double(value), color: color))
                    color = UIColor.colorFromHex(rgbValue: 0xD49C73)
                }
            default:break
        }
        chartView.innerRadius = 65
        chartView.models = models
        chartView.isUserInteractionEnabled = false
        textLayerSettings.label.textColor = .white
        //textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 16)
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        
        chartView.layers = [textLayer]

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        textLayerSettings.label.textGenerator = {slice in
            if slice.data.model.value == 0 {
                return ""
            }
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
    }
}
