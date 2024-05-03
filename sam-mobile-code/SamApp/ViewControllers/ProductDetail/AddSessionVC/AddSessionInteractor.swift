//
//  AddSessionInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

typealias AddSessionInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias AddSessionInteractorFailureHandler = (Error) -> ()

protocol AddSessionInteractorProtocol {
    func addNewSession(productInfo: [String: Any], success: @escaping AddSessionInteractorSuccessHandler, failure: @escaping AddSessionInteractorFailureHandler)
}

class AddSessionInteractor: AddSessionInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func addNewSession(productInfo: [String: Any], success: @escaping AddSessionInteractorSuccessHandler, failure: @escaping AddSessionInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/addNewSession", method: .post, params: productInfo, success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let productDetail = try decoder.decode(ProductDetails.self, from:
                    data!)
                print(productDetail)
                
                success(productDetail, 1)
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
    }
}
