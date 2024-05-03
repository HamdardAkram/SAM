//
//  AccountDetailInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

typealias AccountDetailInteractorSuccessHandler = (String, Int) -> ()
typealias AccountDetailInteractorFailureHandler = (Error) -> ()

protocol AccountDetailInteractorProtocol {
    func updatePassword(withUserInfo: [String: Any], success: @escaping AccountDetailInteractorSuccessHandler, failure: @escaping AccountDetailInteractorFailureHandler)
}

class AccountDetailInteractor: AccountDetailInteractorProtocol {
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func updatePassword(withUserInfo: [String: Any], success: @escaping AccountDetailInteractorSuccessHandler, failure: @escaping AccountDetailInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/login/resetaccountpassword", method: .post, params: withUserInfo, success: { (data, json) in
            
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = jsonObj as? [String: Any] {
                    
                    print(object)
                    success(object["message"] as! String, 1)
                }
                else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Object does not exist"])

                    failure(error)
                }
            } catch let parsingError {
                print("Error", parsingError)
                failure(parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
    }
}
