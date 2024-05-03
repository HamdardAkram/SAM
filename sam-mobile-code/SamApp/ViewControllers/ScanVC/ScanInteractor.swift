//
//  ScanInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

typealias ScanInteractorSuccessHandler = (ProductDetails, Int) -> ()
typealias ScanInteractorFailureHandler = (Error) -> ()

protocol ScanInteractorProtocol {
    
    func getProductDetail(withUserInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    
    func scanProductsIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    func scanProductsOut(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    
    func scanWardrobeProductsIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    func scanWardrobeProductsOut(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    
    func scanForWrongProduct(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    
    func scanNonProductionScanIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
    
    func scanProductWorkFlow(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler)
}

enum ScanError: LocalizedError {
    case noData(String)
    case alreadyScannedIn(String)
    case alreadyScannedOut(String)
    case notScannedInYet(String)
    case noShootDone(String)
    case heldForModel(String)
    public var errorDescription: String? {
       switch self {
       case .noData(_):
           return NSLocalizedString("No Data Available.", comment: "My error")
        case .alreadyScannedIn(_):
            return NSLocalizedString("Product is already scanned In.", comment: "My error")
        case .alreadyScannedOut(_):
            return NSLocalizedString("Product is already scanned Out.", comment: "My error")
        case .notScannedInYet(_):
            return NSLocalizedString("Product is not scanned yet", comment: "My error")
        case .noShootDone(_):
            return NSLocalizedString("No Shoot Done", comment: "My error")
        case .heldForModel(_):
            return NSLocalizedString("Held for model", comment: "My error")
        }
   }
}


class ScanInteractor: ScanInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func getProductDetail(withUserInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/getProductDetails", method: .post, params: withUserInfo, success: { (data, json) in
            
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
    
    func scanProductsIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/productScanIn", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanProductsOut(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/productScanOut", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanForWrongProduct(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/workflow/wrongProduct", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanWardrobeProductsIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        self.networkClient.sendDataWithArray(path: "api/workflow/wardrobeScanIn", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanWardrobeProductsOut(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        self.networkClient.sendDataWithArray(path: "api/workflow/wardrobeScanOut", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanNonProductionScanIn(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        self.networkClient.sendDataWithArray(path: "api/workflow/nonProductionScanIn", method: .post, params: productInfo, success: { (data, json) in
            
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
    
    func scanProductWorkFlow(productInfo: [String: Any], success: @escaping ScanInteractorSuccessHandler, failure: @escaping ScanInteractorFailureHandler) {
        self.networkClient.sendDataWithArray(path: "api/workflow/workflowScan", method: .post, params: productInfo, success: { (data, json) in
            
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
