//
//  ScannedProductDetailViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductDetailView: BaseProtocol {
    func scanInDone()
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int)
}

class ScannedProductDetailViewController: UIViewController {

    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    fileprivate var productDetailAdapter: ScannedProductDetailAdapter!
    
    fileprivate var detailPresenter: ScannedProductDetailPresenterProtocol!
    
    var sessionObject: ProductSession?
    var barcode: String = ""
    var productId: String = ""
    var comingFromSession: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if comingFromSession == true {
            self.navigationItem.title = NSLocalizedString("SESSION_DETAIL", comment: "")
        }
        else {
            self.navigationItem.title = NSLocalizedString("PRODUCT_DETAIL_IN", comment: "")
        }
        setupAdapter()
    }
    

}

fileprivate extension ScannedProductDetailViewController {
    
    func updateDetailAdapter() {
        self.productDetailAdapter.barcode = self.barcode
        self.productDetailAdapter.dataSource = [["title": "Scanned In", "value": convertDate(date: self.sessionObject?.scan_in_date.Value ?? "")], ["title": "Scanned By", "value": self.sessionObject?.scan_in_by ?? ""], ["title": "Photo (Still)", "value": convertDate(date: self.sessionObject?.photo_still_date.Value ?? "")], ["title": "Still Photographer", "value": self.sessionObject?.still_photographer ?? ""], ["title": "Photo Model", "value": convertDate(date: self.sessionObject?.photo_model_date.Value ?? "")], ["title": "Model Photographer", "value": self.sessionObject?.model_photographer ?? ""], ["title": "Photo Mann", "value":  convertDate(date: self.sessionObject?.photo_mannequin_date.Value ?? "")], ["title": "Mann Photographer", "value": self.sessionObject?.mannequin_photographer ?? ""], ["title": "Model Name", "value": self.sessionObject?.model_name ?? ""], ["title": "Copywriting", "value": convertDate(date: self.sessionObject?.copywrite_date.Value ?? "")], ["title": "Video", "value": self.sessionObject?.video_stylist_name ?? ""], ["title": "Scan Out", "value": self.sessionObject?.scan_out_date.Value ?? ""], ["title": "Scan Out By", "value": self.sessionObject?.scan_out_by ?? ""], ["title": "Upload", "value": self.sessionObject?.upload_date.Value ?? ""], ["title": "Still Upload", "value": convertDate(date: self.sessionObject?.still_upload_date.Value ?? "")], ["title": "Model Upload", "value": convertDate(date: self.sessionObject?.model_upload_date.Value ?? "")], ["title": "Mann Upload", "value": convertDate(date: self.sessionObject?.mannequin_upload_date.Value ?? "")], ["title": "Reason", "value": self.sessionObject?.wrongproduct_coment ?? ""]]
    }
    
    func setupAdapter() {
        self.productDetailAdapter = ScannedProductDetailAdapter(collectionView: self.productDetailCollectionView, productDetailView: self)
        self.productDetailCollectionView.dataSource = self.productDetailAdapter
        if comingFromSession == true {
            updateDetailAdapter()
        }
        else {
            setupPresenter()
            let searchDict = ["_id": productId]
            let user = getLoggedInUser()
            let dict = ["client_name": user?.client_name ?? "", "skip": 0, "limit": 1, "search": searchDict] as [String : Any]
            self.detailPresenter.searchProduct(productInfo: dict)
        }
    }
    
    func setupPresenter() {
        let interactor = ScannedProductDetailInteractor(networkClient: NetworkingClient())
        self.detailPresenter = ScannedProductDetailPresenter(detailInteractor: interactor, detailView: self)
    }
}

extension ScannedProductDetailViewController: ProductDetailView {
    func scanInDone() {
//        let searchSB = UIStoryboard.init(name: "Search", bundle: Bundle.main)
//        let refineVC = searchSB.instantiateViewController(withIdentifier: "RefineViewController")
//
//        self.navigationController?.pushViewController(refineVC, animated: true)
    }
    
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int) {
        if productDetail.data.count > 0 {
            let product = productDetail.data[0]
            if product.sessions.count > 0 {
                self.sessionObject = product.sessions[0]
                self.barcode = product.barcode
                updateDetailAdapter()
            }
        }
        
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.productDetailCollectionView.showLoading(withMessage: "Loading..")
    }
    
    func hideActivityIndicator() {
        self.productDetailCollectionView.hideLoading()
    }
    
}
