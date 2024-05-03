//
//  ScannedProductDetailPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/02/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ScannedProductDetailPresenterProtocol {
    func searchProduct(productInfo: [String: Any])
}

class ScannedProductDetailPresenter: ScannedProductDetailPresenterProtocol {
    fileprivate let detailInteractor: ScannedProductDetailInteractorProtocol
    fileprivate weak var detailView: ProductDetailView?
        
    init(detailInteractor: ScannedProductDetailInteractorProtocol, detailView: ProductDetailView) {
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
}
