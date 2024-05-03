//
//  ScannedProductDetailInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/02/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

typealias ScannedProductDetailInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias ScannedProductDetailInteractorFailureHandler = (Error) -> ()

protocol ScannedProductDetailInteractorProtocol {
    func searchProduct(productInfo: [String: Any], success: @escaping ScannedProductDetailInteractorSuccessHandler, failure: @escaping ScannedProductDetailInteractorFailureHandler)
}

class ScannedProductDetailInteractor: ScannedProductDetailInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func searchProduct(productInfo: [String: Any], success: @escaping ScannedProductDetailInteractorSuccessHandler, failure: @escaping ScannedProductDetailInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/search/searchProduct", method: .post, params: productInfo, success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let productDetail = try decoder.decode(ProductDetails.self, from:
                    data!)
                print(productDetail)
                
                success(productDetail, 1)
            } catch let parsingError {
                print("Error", parsingError)
                failure(parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
    }
}
