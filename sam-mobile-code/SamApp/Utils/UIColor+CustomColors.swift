//
//  UIColor+CustomColors.swift
//  SamApp
//
//  Created by Akram on 28/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func baRedColor() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0xd62b2b)
    }

    class func samGray() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0x999999)
    }
    
    class func baLightGray() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0xf7f7f7)
    }
    
    class func samBlack() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0x181818)
    }
    
    class func samRed() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0xee7c00)
    }
    
    class func samBorderGray() -> UIColor {
        return UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.1)
    }
    
    class func facebookBlue() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0x3a5a9b)
    }
    
    class func baYellow() -> UIColor {
        return UIColor.colorFromHex(rgbValue: 0xffdc00)
    }
    
    class func getBackgroundColorAt(indexPath: IndexPath) -> UIColor {
        switch indexPath.row {
            case 0:
                return UIColor.black
            case 1:
                return UIColor.blue
            case 2:
                return UIColor.red
            case 3:
                return UIColor.green
        
        default:
            return UIColor.white
        }
    }
    
    class func colorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    class func colorFromHexWithAlpha(rgbValue:UInt32, alpha: CGFloat)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha: alpha)
    }
    
    class func dynamicBarTintColor() -> UIColor {
        if #available(iOS 13, *) {
            let dynamicTintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case .unspecified:
                        fallthrough
                    case .light:
                        return UIColor.black
                    case .dark:
                        return UIColor.white
                    default:
                        return UIColor.white
                }
            }
            return dynamicTintColor
        }
        else {
            return UIColor.black
        }
    }
    
    class func dynamicBlack() -> UIColor {
            
            if #available(iOS 13, *) {
                let dynamicBlackColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    
                    switch traitCollection.userInterfaceStyle {
                        case .unspecified:
                            fallthrough
                        case .light:
                            return UIColor.black
                        case .dark:
                            return UIColor.lightGray
                        default:
                            return UIColor.lightGray
                    }
                }
                return dynamicBlackColor
            }
            else {
                return UIColor.black
            }
    }
    
    class func dynamicLightGray() -> UIColor {
            
            if #available(iOS 13, *) {
                let dynamicGrayColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    
                    switch traitCollection.userInterfaceStyle {
                        case .unspecified:
                            fallthrough
                        case .light:
                            return UIColor.lightGray
                        case .dark:
                            return UIColor.gray //temp color
                        default:
                            return UIColor.lightGray
                    }
                }
                return dynamicGrayColor
            }
            else {
                return UIColor.lightGray
            }
    }
    
    class func dynamicWhite() -> UIColor {
                
        if #available(iOS 13, *) {
            let dynamicWhiteColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                
                switch traitCollection.userInterfaceStyle {
                    case .unspecified:
                        fallthrough
                    case .light:
                        return UIColor.black
                    case .dark:
                        return UIColor.white
                    default:
                        return UIColor.black
                }
            }
            return dynamicWhiteColor
        }
        else {
            return UIColor.black
        }
    }
    
    class func dynamicCheckBox() -> UIColor {
                    
            if #available(iOS 13, *) {
                let dynamicCheckBoxColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                    
                    switch traitCollection.userInterfaceStyle {
                        case .unspecified:
                            fallthrough
                        case .light:
                            return UIColor.white
                        case .dark:
                            return UIColor.black
                        default:
                            return UIColor.white
                    }
                }
                return dynamicCheckBoxColor
            }
            else {
                return UIColor.white
            }
    }
    
    static var barTintColor: UIColor {
            if #available(iOS 13, *) {
                return .systemBackground
            }
            return UIColor.samBlack()
        }
    
    static var background: UIColor {
            if #available(iOS 13, *) {
                return .systemBackground
            }
            return UIColor.white
    }
    
    static var labelColor: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        return UIColor.white
    }
}
