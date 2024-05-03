//
//  AppStoryboard.swift
//  SamApp
//
//  Created by Muhammad Akram on 18/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case Main, Home, TabBarVC, Search, Product, Profile, Scan, Report, Other
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func initailViewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        return instance.instantiateInitialViewController() as! T
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyBoardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
}

extension UIViewController {
   class var storyboardID : String {
     return "\(self)"
   }
    
    static func instantiate(fromStoryboard: AppStoryboard) -> Self {
        return fromStoryboard.viewController(viewControllerClass: self)
    }
    
    static func initailViewController(fromStoryboard: AppStoryboard) -> Self {
        return fromStoryboard.initailViewController(viewControllerClass: self)
    }
}
