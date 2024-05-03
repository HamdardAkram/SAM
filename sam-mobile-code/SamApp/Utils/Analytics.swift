//
//  Analytics.swift
//  BrandAlley
//
//  Created by Akram on 02/04/18.
//  Copyright © 2018 BrandAlley. All rights reserved.
//

import UIKit


class Analytics: NSObject {

    class func trackEvent(name: String, parameters: [String : String]) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        let eventTracker: NSObject = GAIDictionaryBuilder.createEvent(
            withCategory: parameters[CATEGORY],
            action: parameters[ACTION],
            label: parameters[LABEL],
            value: nil).build()
        tracker.send(eventTracker as! [AnyHashable : Any])
    }
    
    class func measureProduct(measureType: Int, product: Product, parameters: [String : String]) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        let eproduct: GAIEcommerceProduct = GAIEcommerceProduct.init()
        eproduct.setId("P12345")
        eproduct.setName(product.name)
        eproduct.setCategory(parameters[CATEGORY])
        eproduct.setBrand("UCB")
        eproduct.setVariant("Black")
        eproduct.setCustomDimension(1, value: "Member")
        
        var builder = GAIDictionaryBuilder.createScreenView()
        
        switch measureType {
            case 0: //measure product impression
                builder?.addProductImpression(eproduct, impressionList: "Product List", impressionSource: "Product List")
                tracker.set(kGAIScreenName, value: "Product Screen")
            
            case 1: //measure transaction
                eproduct.setCouponCode("APPARELSALE")
                eproduct.setQuantity(1)
                eproduct.setPrice(30)
                
                builder = GAIDictionaryBuilder.createEvent(withCategory: "Ecommerce", action: "Purchase", label: "", value: 0)
                
                let action = GAIEcommerceProductAction.init()
                action.setAction("Purchase")
                action.setTransactionId("T12345")
                action.setAffiliation("UCB Store - Online")
                action.setRevenue(35)
                action.setTax(2)
                action.setShipping(5)
                action.setCouponCode("SUMMER2018")
                
                builder?.setProductAction(action)
                builder?.add(eproduct)
            default:
                print("")
        }
        tracker.send(builder?.build() as! [AnyHashable : Any])
    }
}
