//
//  SearchResultViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SearchResultView: BaseProtocol {
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int)
    func hideLoadMoreIndicator()
}

class SearchResultViewController: UIViewController {

    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    fileprivate var searchResultAdapter: SearchResultAdapter!
    fileprivate var searchPresenter: SearchResultPresenterProtocol!
    
    var sectionItems = [RefineSection]()
    var productDetail: ProductDetails?
    
    var totalProducts: Int = 0
    var limit:Int = 15
    var startOffset:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("SEARCH_RESULT_IN", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdapter()
        setupPresenter()
        
//        if self.isMovingToParent {
//            let dict = LocalHelper.shared.searchParameterDict(sectionItems: self.sectionItems, startOffset: startOffset, limit: limit)
//            self.searchPresenter.searchProduct(productInfo: dict as [String : Any], withOffset: startOffset, count: limit)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchResultAdapter = nil
        self.searchPresenter = nil
    }
}

fileprivate extension SearchResultViewController {
    func setupAdapter() {
        self.searchResultAdapter = SearchResultAdapter(collectionView: self.searchResultCollectionView, delegate: self)
        self.searchResultCollectionView.dataSource = self.searchResultAdapter
        if let product = self.productDetail {
            self.searchResultAdapter.productDetails = product
        }
    }
    
    func setupPresenter() {
        let interactor = SearchResultInteractor(networkClient: NetworkingClient())
        self.searchPresenter = SearchResultPresenter(searchInteractor: interactor, searchResultView: self, totalProducts: self.totalProducts)
    }
}

extension SearchResultViewController: SearchResultView {
    func showActivityIndicator(withMessage message: String) {
        self.searchResultCollectionView.showLoading(withMessage: "Loading...")
    }
    
    func hideActivityIndicator() {
        self.searchResultCollectionView.hideLoading()
    }
    
    func hideLoadMoreIndicator() {
        self.searchResultAdapter.isLoading = true
        self.searchResultAdapter.hideLoadMoreIndicator()
    }
    
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int) {
        DispatchQueue.main.async {
            
            if self.startOffset > 0 {
                guard var currentItems: [ProductData] = self.searchResultAdapter.productDetails?.data else {
                    return
                }
                currentItems.append(contentsOf: productDetail.data)
                self.searchResultAdapter.productDetails?.data = currentItems
                self.searchResultCollectionView.reloadData()
            }
            else {
                self.searchResultAdapter.productDetails = productDetail
            }
            self.startOffset = self.startOffset + self.limit
        }
    }
}

extension SearchResultViewController: SearchResultAdapterDelegate {
    func didTapOnRow(indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController.instantiate(fromStoryboard: .Product)
        productDetailVC.selectedProductIndex = indexPath.row
        if let product = self.searchResultAdapter.productDetails?.data[indexPath.row] {
            productDetailVC.productsFromSearchResult = self.searchResultAdapter.productDetails
        }
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func fetchMoreProducts() {
        let dict = LocalHelper.shared.searchParameterDict(sectionItems: self.sectionItems, startOffset: startOffset, limit: limit)
        self.searchPresenter.searchProduct(productInfo: dict, withOffset: startOffset, count: limit)
    }
}
