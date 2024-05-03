//
//  DeeplinkParser.swift
//  BrandAlley
//
//  Created by Akram on 19/04/18.
//  Copyright © 2018 BrandAlley. All rights reserved.
//

import UIKit

class DeeplinkParser: NSObject {
    static let shared = DeeplinkParser()
    private override init() { }
    
    func parseDeepLink(_ url: URL) -> DeeplinkType? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            return nil
        }
        var pathComponents = components.path.components(separatedBy: "/")
        pathComponents.removeFirst()
        
        switch host {
            case "basket":
                return DeeplinkType.basket
            case "checkout":
                return DeeplinkType.checkout
            default:
                break
        }
        return nil
    }
}
