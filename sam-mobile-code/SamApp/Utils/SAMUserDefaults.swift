//
//  SAMUserDefaults.swift
//  SamApp
//
//  Created by Muhammad Akram on 16/12/23.
//  Copyright © 2023 Muhammad Akram. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var sharedContainer: UserDefaults? {
        return UserDefaults(suiteName: "com.packshot.SamApp")
    }
    
    static var authToken:String? {
        set{
            UserDefaults.standard.set(newValue, forKey: "token")
        }
        get{
            return UserDefaults.standard.string(forKey: "token")
        }
    }
}
