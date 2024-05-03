//
//  Appearance.swift
//  SamApp
//
//  Created by Akram on 21/03/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class Appearance: NSObject {

    static func configureAppearance() {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.samRed()
        navigationBarAppearace.barTintColor = UIColor.samBlack()
        navigationBarAppearace.titleTextAttributes = [kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.samRed(), kCTFontAttributeName as NSAttributedString.Key: UIFont.tofinoMediumEighteen()]
        
        UITabBarItem.appearance().setTitleTextAttributes([kCTFontAttributeName as NSAttributedString.Key: UIFont.tofinoRegularEleven(), kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.white], for: .normal)

        UITabBar.appearance().tintColor = UIColor.samRed()
    }
}
