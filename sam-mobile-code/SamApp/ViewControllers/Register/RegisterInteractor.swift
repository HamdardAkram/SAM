//
//  RegisterInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 18/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias RegisterInteractorSuccessHandler = (JSON?) -> ()
typealias RegisterInteractorFailureHandler = (Error) -> ()

protocol RegisterInteractorProtocol {
    func register(withUserInfo: [String: Any], success: @escaping RegisterInteractorSuccessHandler, failure: @escaping RegisterInteractorFailureHandler)
}

class RegisterInteractor: RegisterInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func register(withUserInfo: [String: Any], success: @escaping RegisterInteractorSuccessHandler, failure: @escaping RegisterInteractorFailureHandler) {
    
        self.networkClient.sendDataWithArray(path: "api/mobile/appRegister", method: .post, params: withUserInfo, success: { (data, json) in
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = jsonObj as? [String: Any] {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(object, forKey: REGISTRATION)
                    defaults.synchronize()
                    
                    print(object)
                }
            } catch {
                
            }
            success(json)
            
        }) { (error) in
            failure(error)
        }
    }
}
