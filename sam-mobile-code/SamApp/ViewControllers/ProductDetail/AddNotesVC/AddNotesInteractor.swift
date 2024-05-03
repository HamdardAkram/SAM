//
//  AddNotesInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

typealias AddNotesInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias AddNotesInteractorFailureHandler = (Error) -> ()

protocol AddNotesInteractorProtocol {
    func getExistingNotes(productInfo: [String: Any], success: @escaping AddNotesInteractorSuccessHandler, failure: @escaping AddNotesInteractorFailureHandler)
    func addNewNote(productInfo: [String: Any], success: @escaping AddNotesInteractorSuccessHandler, failure: @escaping AddNotesInteractorFailureHandler)
}

class AddNotesInteractor: AddNotesInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func getExistingNotes(productInfo: [String: Any], success: @escaping AddNotesInteractorSuccessHandler, failure: @escaping AddNotesInteractorFailureHandler) {
        self.networkClient.sendDataWithArray(path: "api/product/getProduct", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func addNewNote(productInfo: [String: Any], success: @escaping AddNotesInteractorSuccessHandler, failure: @escaping AddNotesInteractorFailureHandler) {
        
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
