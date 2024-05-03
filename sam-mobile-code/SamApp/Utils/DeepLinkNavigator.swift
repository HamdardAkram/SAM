//
//  DeepLinkNavigator.swift
//  BrandAlley
//
//  Created by Akram on 19/04/18.
//  Copyright © 2018 BrandAlley. All rights reserved.
//

import UIKit

class DeepLinkNavigator: NSObject {

    static let shared = DeepLinkNavigator()
    private override init() {
        
    }
    
    func getVisibleViewController() -> UIViewController? {
        let window = UIApplication.shared.keyWindow
        if window?.rootViewController?.isKind(of: UINavigationController.self) == false {
            return nil
        }
        else {
            let navC = window?.rootViewController as? UINavigationController
            var visibleVC = navC?.visibleViewController
            
            if let vc = visibleVC as? TabBarViewController {
                let selectedIndex = vc.selectedIndex
                let navC: UINavigationController = vc.viewControllers![selectedIndex] as! UINavigationController
                visibleVC = navC.topViewController!
            }
            return visibleVC!
        }
    }
    
    func proceedToDeeplink(_ type: DeeplinkType) {
        
        if let visibleVC = getVisibleViewController() {
        
            switch type {
                case .basket:
                    let basketVC = BasketViewController.viewController()
                    visibleVC.navigationController?.pushViewController(basketVC, animated: true)
                case .checkout:
                    var basketItems = [BasketItem]()
                    for i in 0 ..< 10 {
                        let basketItem = BasketItem(name: "Tommy Hilfigure", type: "Black Lora Beau Jersey V Neck Dress", size: "40", price: 20, discount: 10 + i)
                        basketItems.append(basketItem)
                    }
                    let basket: Basket = Basket(basketItems: basketItems)
                    let checkoutVC = CheckoutViewController.viewController(basket: basket)
                    visibleVC.navigationController?.pushViewController(checkoutVC, animated: true)
                case .account:
                    let accountVC = AccountViewController.viewController()
                    visibleVC.navigationController?.pushViewController(accountVC, animated: true)
                case .product:
                    let productVC = ProductsViewController.viewController()
                    visibleVC.navigationController?.pushViewController(productVC, animated: true)
            }
        }
    }
}
