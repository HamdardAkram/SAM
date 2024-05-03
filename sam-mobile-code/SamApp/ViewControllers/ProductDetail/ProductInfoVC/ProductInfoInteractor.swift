//
//  ProductInfoInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

typealias ProductInfoInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias ProductInfoInteractorFailureHandler = (Error) -> ()

protocol ProductInfoInteractorProtocol {
    func updateProductInfo(productInfo: [String: Any], success: @escaping ProductInfoInteractorSuccessHandler, failure: @escaping ProductInfoInteractorFailureHandler)
}

class ProductInfoInteractor: ProductInfoInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func updateProductInfo(productInfo: [String: Any], success: @escaping ProductInfoInteractorSuccessHandler, failure: @escaping ProductInfoInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/product/productUpdate", method: .post, params: productInfo, success: { (data, json) in
            
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
