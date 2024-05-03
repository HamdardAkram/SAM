//
//  DeepLinkManager.swift
//  BrandAlley
//
//  Created by Akram on 19/04/18.
//  Copyright © 2018 BrandAlley. All rights reserved.
//

import UIKit

enum DeeplinkType {
   
    case basket
    case checkout
    case account
    case product
}

class DeepLinkManager: NSObject {

    static let shared = DeepLinkManager()
    
    fileprivate override init() {
        
    }
    private var deeplinkType: DeeplinkType?
    
    func checkDeepLink() {
        guard let deeplinkType = deeplinkType else {
            return
        }
        
        DeepLinkNavigator.shared.proceedToDeeplink(deeplinkType)
        // reset deeplink after handling
        self.deeplinkType = nil
    }
    
    @discardableResult
    func handleShortcut(item: UIApplicationShortcutItem) -> Bool {
        deeplinkType = ShortcutParser.shared.handleShortcut(item)
        return deeplinkType != nil
    }
    
    @discardableResult
    func handleDeeplink(url: URL) -> Bool {
        deeplinkType = DeeplinkParser.shared.parseDeepLink(url)
        return deeplinkType != nil
    }
    
    func handleSpotlightSearch() {
        deeplinkType = DeeplinkType.product
    }
}
