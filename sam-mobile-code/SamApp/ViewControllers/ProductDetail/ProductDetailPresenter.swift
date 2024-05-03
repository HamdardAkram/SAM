//
//  ProductDetailPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductDetailPresenterProtocol {
    func searchProduct(productInfo: [String: Any])
    func getProductImages(productInfo: [String: Any])
    func updateProductInfo(productInfo: [String: Any])
}

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    fileprivate let detailInteractor: ProductDetailInInteractorProtocol
    fileprivate weak var detailView: ProductPageDetailView?
        
    init(detailInteractor: ProductDetailInInteractorProtocol, detailView: ProductPageDetailView) {
        self.detailInteractor = detailInteractor
        self.detailView = detailView
    }
    
    func searchProduct(productInfo: [String: Any]) {
        
        self.detailView?.showActivityIndicator(withMessage: "Searching..")
        self.detailInteractor.searchProduct(productInfo: productInfo, success: { (productDetail, code) in
            
            self.detailView?.productDetailStatus(productDetail: productDetail, message: "", code: 0)
            self.detailView?.hideActivityIndicator()
        }) { (error) in
            
            self.detailView?.hideActivityIndicator()
            self.detailView?.showError(error: error)
        }
    }
    
    func getProductImages(productInfo: [String: Any]) {
        self.detailView?.showActivityIndicator(withMessage: "Fetching images..")
        self.detailInteractor.getProductImages(productInfo: productInfo, success: { (imageData, code) in
            
            self.detailView?.productImages(productImages: imageData.images, message: imageData.message, code: 0)
            self.detailView?.hideActivityIndicator()
        }) { (error) in
            
            self.detailView?.hideActivityIndicator()
            self.detailView?.showError(error: error)
        }
    }
    
    func updateProductInfo(productInfo: [String: Any]) {
        
        self.detailView?.showActivityIndicator(withMessage: "Updating..")
        self.detailInteractor.updateProductInfo(productInfo: productInfo, success: { (productDetail, code) in
            
            var message = "success"
            if productDetail.statusCode.Value == "200" || productDetail.statusCode.Value == "200.0" {
                message = "product updated successfully"
            }
            self.detailView?.addedNewOutfit(message: message, code: 0)
            self.detailView?.hideActivityIndicator()
        }) { (error) in
            
            self.detailView?.hideActivityIndicator()
            self.detailView?.showError(error: error)
        }
    }
}
