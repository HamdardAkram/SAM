//
//  ScanPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol ScanPresenterProtocol {
    func getProductDetail(withUserInfo: [String: Any])
    func getProductDetailForScanOut(withUserInfo: [String: Any])
    
    func getProductDetailForWardrobeIn(productInfo: [String: Any])
    func getProductDetailForWardrobeOut(productInfo: [String: Any])
    
    func getProductDetailToSetStatus(productInfo: [String: Any])
    func getProductDetailForWorkFlowScan(withUserInfo: [String: Any])
    
    func scanProductsIn(productInfo: [String: Any])
    func scanProductsOut(productInfo: [String: Any])
    
    func scanForWrongProduct(productInfo: [String: Any])
    func scanWardrobeProductsIn(productInfo: [String: Any])
    func scanWardrobeProductsOut(productInfo: [String: Any])
    
    func scanNonProductionScanIn(productInfo: [String: Any])
    func scanProductWorkFlow(productInfo: [String: Any])
}

class ScanPresenter: ScanPresenterProtocol {
    
    fileprivate let scanInteractor: ScanInteractorProtocol
    fileprivate weak var scanView: BaseProtocol?
        
    init(scanInteractor: ScanInteractorProtocol, scanView: BaseProtocol) {
        self.scanInteractor = scanInteractor
        self.scanView = scanView
    }
    
    func getProductDetail(withUserInfo: [String: Any]) {
        
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail...")
        self.scanInteractor.getProductDetail(withUserInfo: withUserInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = "Successfully added in scanned in list"
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.scan_in_date.Value.count > 0 {
                    message = "Product is already scanned In"
                    isValidProduct = false
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func getProductDetailForScanOut(withUserInfo: [String: Any]) {
        
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail..")
        self.scanInteractor.getProductDetail(withUserInfo: withUserInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = "Successfully added in scanned out list"
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.scan_out_date.Value.count > 0 {
                    message = "Product is already scanned Out"
                    isValidProduct = false
                }
                
                if data.scan_in_date.Value.isEmpty {
                    message = "Product is not scanned In yet"
                    isValidProduct = false
                }
                
                if data.sessions.count > 0 {
                    
                    let session = data.sessions.max { (session1, session2) -> Bool in
                        session1.product_session_id < session2.product_session_id
                    }
                    
                    if session?.wrong_code.Value.isEmpty == true {
                        if (session?.photo_model_date.Value.isEmpty)! && (session?.photo_mannequin_date.Value.isEmpty)! && (session?.photo_still_date.Value.isEmpty)! {
                            message = "No Shot Done"
                            isValidProduct = false
                        }
                        else {
                            
                        }
                    }
                    else {
                        guard let wrongCode = session?.wrong_code.Value else {
                            return
                        }
                        if Int(wrongCode)! < 99 {
                            isValidProduct = true
                        }
                        if Int(wrongCode)! > 99 {
                            if (session?.photo_still_date.Value.isEmpty)! {
                                message = "Held for model"
                                isValidProduct = false
                            }
                            else {
                                isValidProduct = true
                            }
                        }
                    }
                }
                
                if data.wardrobe_product == 1 {
                    isValidProduct = false
                    message = "It is wardrobe product and cannot be scanned out"
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func getProductDetailForWardrobeIn(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail..")
        self.scanInteractor.getProductDetail(withUserInfo: productInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = "Successfully added in wardrobe scanned In list"
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.wardrobe_product == 1 {
                    message = "Product is already in wardrobe"
                    isValidProduct = false
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func getProductDetailForWardrobeOut(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail..")
        self.scanInteractor.getProductDetail(withUserInfo: productInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = "Successfully added in wardrobe scanned Out list"
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.wardrobe_product == 0 {
                    message = "Product is not available in wardrobe"
                    isValidProduct = false
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func getProductDetailToSetStatus(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail..")
        self.scanInteractor.getProductDetail(withUserInfo: productInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = ""
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.scan_in_date.Value.isEmpty {
                    message = "Product is not scanned In yet"
                    isValidProduct = false
                }
                if data.scan_out_date.Value.count > 0 {
                    message = "Product is already scanned Out"
                    isValidProduct = false
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanProductsIn(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning In..")
        self.scanInteractor.scanProductsIn(productInfo: productInfo, success: { (productDetail, code) in
            
            if let scanview = self.scanView as? ScanView {
                scanview.scanProductStatus(message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanProductsOut(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning Out..")
        self.scanInteractor.scanProductsOut(productInfo: productInfo, success: { (productDetail, code) in
            if let scanview = self.scanView as? ScanView {
                scanview.scanProductStatus(message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanForWrongProduct(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning wrong product..")
        self.scanInteractor.scanForWrongProduct(productInfo: productInfo, success: { (productDetail, code) in
            
            if productDetail.statusCode.Value == "200" || productDetail.statusCode.Value == "200.0" {
                
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.scanWrongProduct(productDetail: productDetail, message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanWardrobeProductsIn(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning wardrobe In..")
        self.scanInteractor.scanWardrobeProductsIn(productInfo: productInfo, success: { (productDetail, code) in
            
            if let scanview = self.scanView as? ScanView {
                scanview.scanProductStatus(message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanWardrobeProductsOut(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning wardrobe Out..")
        self.scanInteractor.scanWardrobeProductsOut(productInfo: productInfo, success: { (productDetail, code) in
            
            if let scanview = self.scanView as? ScanView {
                scanview.scanProductStatus(message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanNonProductionScanIn(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning non production...")
        self.scanInteractor.scanNonProductionScanIn(productInfo: productInfo, success: { (productDetail, code) in
            
            if let scanview = self.scanView as? ScanView {
                scanview.scanProductStatus(message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func getProductDetailForWorkFlowScan(withUserInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Fetching detail...")
        self.scanInteractor.getProductDetail(withUserInfo: withUserInfo, success: { (productDetail, code) in
            
            var isValidProduct: Bool = true
            var message: String = ""
            if productDetail.data.count == 0 && (productDetail.statusCode.Value == "105" || productDetail.statusCode.Value == "105.0") {
                message = "No Data Available"
                isValidProduct = false
            }
            else {
                let data = productDetail.data[0]
                if data.scan_out_date.Value.count > 0 {
                    message = "Product is already scanned Out"
                    isValidProduct = false
                }
                
                if data.scan_in_date.Value.isEmpty {
                    message = "Product is not scanned In yet"
                    isValidProduct = false
                }
                
                if data.sessions.count > 0 {
                    
                    let session = data.sessions.max { (session1, session2) -> Bool in
                        session1.product_session_id < session2.product_session_id
                    }
                    
                    if let preferences = UserDefaults.standard.value(forKey: USER_PREFERENCES) as? [String: Any] {
                        
                        guard let type = preferences[PHOTOGRAPHY_TYPE] as? String else {
                            return
                        }
                        //check session object
                        switch type {
                        case STILLS:
                            if session?.photo_still_date.Value.isEmpty == false {
                                message = "Already Shot"
                                isValidProduct = false
                            }
                        case MODEL:
                            if session?.photo_model_date.Value.isEmpty == false {
                                message = "Already Shot"
                                isValidProduct = false
                            }
                        case MANNEQUIN:
                            if session?.photo_mannequin_date.Value.isEmpty == false {
                                message = "Already Shot"
                                isValidProduct = false
                            }
                        default:
                            print("")
                        }
                    }
                }
            }
                if let barcodeview = self.scanView as? BarcodeScanView {
                    barcodeview.productDetailStatus(productDetail: productDetail, message: message, isValid: isValidProduct)
                }
                self.scanView?.hideActivityIndicator()
            
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
    
    func scanProductWorkFlow(productInfo: [String: Any]) {
        self.scanView?.showActivityIndicator(withMessage: "Scanning workflow...")
        self.scanInteractor.scanProductWorkFlow(productInfo: productInfo, success: { (productDetail, code) in
            
            if productDetail.statusCode.Value == "200" || productDetail.statusCode.Value == "200.0" {
                if let preferences = UserDefaults.standard.value(forKey: USER_PREFERENCES) as? [String: Any] {
                    guard let type = preferences[PHOTOGRAPHY_TYPE] as? String else {
                        return
                    }
                    switch type {
                    case STILLS:
                        UserDefaults.standard.set(productDetail.totalscanned, forKey: STILLS_SCAN_COUNT)
                    case MODEL:
                        UserDefaults.standard.set(productDetail.totalscanned, forKey: MODELS_SCAN_COUNT)
                    case MANNEQUIN:
                        UserDefaults.standard.set(productDetail.totalscanned, forKey: MANNEQUIN_SCAN_COUNT)
                    default:
                        print("")
                    }
                    UserDefaults.standard.synchronize()
                }
            }
            if let barcodeview = self.scanView as? BarcodeScanView {
                barcodeview.scanWorkFlowStatus(productDetail: productDetail, message: productDetail.message, code: 0)
            }
            self.scanView?.hideActivityIndicator()
        }) { (error) in
            
            self.scanView?.hideActivityIndicator()
            self.scanView?.showError(error: error)
        }
    }
}
