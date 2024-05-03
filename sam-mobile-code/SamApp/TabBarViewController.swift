//
//  TabBarViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 31/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        print("tabvc")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navC = viewController as? UINavigationController else {
            return
        }
        if let barcodeVC = navC.topViewController as? BarcodeReaderViewController {
            barcodeVC.barcodeOption = .workFlowScan
        }
    }
  

}

