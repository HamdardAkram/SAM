//
//  ProductInfoPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductInfoPresenterProtocol {
    func updateProductInfo(productInfo: [String: Any])
}

class ProductInfoPresenter: ProductInfoPresenterProtocol {
    fileprivate let infoInteractor: ProductInfoInteractorProtocol
    fileprivate weak var infoView: ProductInfoView?
        
    
    
    init(infoInteractor: ProductInfoInteractorProtocol, infoView: ProductInfoView) {
        self.infoInteractor = infoInteractor
        self.infoView = infoView
    }
    
    func updateProductInfo(productInfo: [String: Any]) {
        
        self.infoView?.showActivityIndicator(withMessage: "Updating..")
        self.infoInteractor.updateProductInfo(productInfo: productInfo, success: { (productDetail, code) in
            
            var message = "success"
            if productDetail.statusCode.Value == "200" || productDetail.statusCode.Value == "200.0" {
                message = "product updated successfully"
            }
            self.infoView?.productUpdated(productInfo: productDetail, message: message, code: 0)
            self.infoView?.hideActivityIndicator()
        }) { (error) in
            
            self.infoView?.hideActivityIndicator()
            self.infoView?.showError(error: error)
        }
    }
}
