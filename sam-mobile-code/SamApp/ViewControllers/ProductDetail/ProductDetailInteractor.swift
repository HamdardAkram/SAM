//
//  ProductDetailInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
typealias ProductDetailInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias ProductDetailInteractorFailureHandler = (Error) -> ()

typealias ProductImagesSuccessHandler = (ImageData, Int) -> ()

protocol ProductDetailInInteractorProtocol {
    func searchProduct(productInfo: [String: Any], success: @escaping ProductDetailInteractorSuccessHandler, failure: @escaping ProductDetailInteractorFailureHandler)
    
    func getProductImages(productInfo: [String: Any], success: @escaping ProductImagesSuccessHandler, failure: @escaping ProductDetailInteractorFailureHandler)
    
    func updateProductInfo(productInfo: [String: Any], success: @escaping ProductInfoInteractorSuccessHandler, failure: @escaping ProductInfoInteractorFailureHandler)
}

class ProductDetailInteractor: ProductDetailInInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func searchProduct(productInfo: [String: Any], success: @escaping ProductDetailInteractorSuccessHandler, failure: @escaping ProductDetailInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/search/searchProduct", method: .post, params: productInfo, success: { (data, json) in
            print("Search response for product detail", json)
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
    
    func getProductImages(productInfo: [String: Any], success: @escaping ProductImagesSuccessHandler, failure: @escaping ProductDetailInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/mobile/productImages", method: .post, params: productInfo, success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let imageDetail = try decoder.decode(ImageData.self, from:
                    data!)
                print(imageDetail)
                
                success(imageDetail, 1)
                
            } catch let parsingError {
                print("Error", parsingError)
                failure(parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
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
