//
//  SearchResultInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

typealias SearchResultInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias SearchResultInteractorFailureHandler = (Error) -> ()

protocol SearchResultInteractorProtocol {
    func searchProduct(withOffset: Int, count: Int, productInfo: [String: Any], success: @escaping SearchResultInteractorSuccessHandler, failure: @escaping SearchResultInteractorFailureHandler)
}

class SearchResultInteractor: SearchResultInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func searchProduct(withOffset: Int, count: Int, productInfo: [String: Any], success: @escaping SearchResultInteractorSuccessHandler, failure: @escaping SearchResultInteractorFailureHandler) {
        
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
