//
//  EditSessionInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

typealias EditSessionInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias EditSessionInteractorFailureHandler = (Error) -> ()

protocol EditSessionInteractorProtocol {
    func editSession(productInfo: [String: Any], success: @escaping EditSessionInteractorSuccessHandler, failure: @escaping EditSessionInteractorFailureHandler)
}

class EditSessionInteractor: EditSessionInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func editSession(productInfo: [String: Any], success: @escaping EditSessionInteractorSuccessHandler, failure: @escaping EditSessionInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/editSession", method: .post, params: productInfo, success: { (data, json) in
            
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
