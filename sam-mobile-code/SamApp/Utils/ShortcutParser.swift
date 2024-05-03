//
//  ShortcutParser.swift
//  BrandAlley
//
//  Created by Akram on 19/04/18.
//  Copyright © 2018 BrandAlley. All rights reserved.
//

import UIKit

enum ShortcutKey: String {
    case basket = "com.brandalley.basket"
    case checkout = "com.brandalley.checkout"
    case myAccout = "com.brandalley.myAccount"
}

class ShortcutParser: NSObject {

    static let shared = ShortcutParser()
    private override init() {
        
    }
    
    func registerShortcuts() {
        let basketIcon = UIApplicationShortcutIcon(templateImageName: "Alert Icon")
        let basketShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.basket.rawValue, localizedTitle: "Basket", localizedSubtitle: nil, icon: basketIcon, userInfo: nil)
        let checkoutIcon = UIApplicationShortcutIcon(templateImageName: "Messenger Icon")
        let checkoutShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.checkout.rawValue, localizedTitle: "Checkout", localizedSubtitle: nil, icon: checkoutIcon, userInfo: nil)
        let accountIcon = UIApplicationShortcutIcon(templateImageName: "Account Icon")
        let accountShortcutItem = UIApplicationShortcutItem(type: ShortcutKey.checkout.rawValue, localizedTitle: "My Account", localizedSubtitle: nil, icon: accountIcon, userInfo: nil)
        UIApplication.shared.shortcutItems = [basketShortcutItem, checkoutShortcutItem, accountShortcutItem]
    }
    
    func handleShortcut(_ shortcut: UIApplicationShortcutItem) -> DeeplinkType? {
        switch shortcut.type {
        case ShortcutKey.basket.rawValue:
            return .basket
        case ShortcutKey.checkout.rawValue:
            return .checkout
        case ShortcutKey.myAccout.rawValue:
            return .account
        default:
            return nil
        }
    }
}
