//
//  SearchResultPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol SearchResultPresenterProtocol {
    func searchProduct(productInfo: [String: Any], withOffset: Int, count: Int)
}

typealias Page = Int

enum State {
    case loading
    case ready
}

class SearchResultPresenter: SearchResultPresenterProtocol {
    fileprivate let searchInteractor: SearchResultInteractorProtocol
    fileprivate weak var searchResultView: SearchResultView?
        
    fileprivate var loadingState: [Page: State] = [0: State.ready]
    fileprivate var totalProducts: Int = 0
    
    init(searchInteractor: SearchResultInteractorProtocol, searchResultView: SearchResultView, totalProducts: Int) {
        self.searchInteractor = searchInteractor
        self.searchResultView = searchResultView
        self.totalProducts = totalProducts
    }
    
    func searchProduct(productInfo: [String: Any], withOffset: Int, count: Int) {
        if withOffset >= totalProducts && withOffset > 0 {
            self.searchResultView?.hideLoadMoreIndicator()
            print("No more products")
            return
        }
        if loadingState[withOffset] == State.loading {
            return
        }
        loadingState[withOffset] = State.loading
        self.searchResultView?.showActivityIndicator(withMessage: "Searching...")
        self.searchInteractor.searchProduct(withOffset: withOffset, count: count, productInfo: productInfo, success: { (productDetail, code) in
            self.loadingState[withOffset] = State.ready
            self.totalProducts = productDetail.totalRecords
            self.searchResultView?.productDetailStatus(productDetail: productDetail, message: "", code: 0)
            self.searchResultView?.hideActivityIndicator()
        }) { (error) in
            self.loadingState[withOffset] = State.ready
            self.searchResultView?.hideActivityIndicator()
            self.searchResultView?.showError(error: error)
        }
    }
}
