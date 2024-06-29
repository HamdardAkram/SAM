//
//  ProductDetailViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SKPhotoBrowser

protocol ProductPageDetailView: BaseProtocol {
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int)
    func productImages(productImages: [ProductImages], message: String, code: Int)
    func addedNewOutfit(message: String, code: Int)
}

protocol ProductDetailViewControllerDelegate: AnyObject {
    func productDetailForOutfit(product: ProductDetails)
}

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    fileprivate var detailAdapter: ProductDetailAdapter!
    fileprivate var detailPresenter: ProductDetailPresenterProtocol!
    
    var countLabel: UILabel?
    var selectedProductIndex: Int = 0
    var labelCount: Int = 0
    var productsFromSearchResult: ProductDetails?
    var productId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("PRODUCT_DETAILS", comment: "")
        
//        if productId.isEmpty {
//
//        }
//        else {
//            let searchDict = ["_id": self.productId]
//            let user = getLoggedInUser()
//            let dict = ["client_name": user?.client_name ?? "", "skip": 0, "limit": 1, "search": searchDict] as [String : Any]
//            self.detailPresenter.searchProduct(productInfo: dict)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if detailTableView.tableHeaderView == nil {
            detailTableView.tableHeaderView = UIView()
            detailTableView.tableHeaderView?.backgroundColor = .black
        }
            
        if let thv = detailTableView.tableHeaderView {
            var frame = thv.frame
            frame.size.height = 420
            thv.frame = frame
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdapter()
        setupPresenter()
        
        if productId.isEmpty {
            if (self.productsFromSearchResult?.data.count)! > 1 {
                setupNavigationBar()
            }
            self.detailAdapter.productDetail = self.productsFromSearchResult
            self.detailAdapter.currentProductIndex = self.selectedProductIndex
            labelCount = self.selectedProductIndex + 1
            self.countLabel?.text = String(labelCount) + " of " + String(self.productsFromSearchResult?.data.count ?? 0)
            
            fetchProductImages()
        }
        else {
            getUpdatedProduct(pid: self.productId)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.countLabel?.removeFromSuperview()
        self.navigationController?.navigationBar.viewWithTag(100)?.removeFromSuperview()
        self.navigationController?.navigationBar.viewWithTag(101)?.removeFromSuperview()
        self.detailAdapter = nil
        self.detailPresenter = nil
    }
    
    func fetchProductImages() {
        let user = getLoggedInUser()
        let defaults = UserDefaults.standard
        let config = defaults.dictionary(forKey: CONFIGURATION)
        guard let configuration = config?["config"] as? [String: Any] else {
            return
        }
        guard let uniqueIds = configuration["unique_identifiers"] as? [String: String] else {
            return
        }
        let uniqueID = uniqueIds[user?.client_name ?? ""]
        let imageIdentifier = self.detailAdapter.productDetail?.data[selectedProductIndex].productInfo[uniqueID ?? ""]
        let dict: [String: Any] = ["client_name": user?.client_name ?? "", "image_identifier": imageIdentifier?.Value ?? ""]
        self.detailPresenter.getProductImages(productInfo: dict)
    }
    
    func getUpdatedProduct(pid: String) {
        setupAdapter()
        setupPresenter()
        
        let searchDict = ["_id": pid]
        let user = getLoggedInUser()
        let dict = ["client_name": user?.client_name ?? "", "skip": 0, "limit": 1, "search": searchDict] as [String : Any]
        self.detailPresenter.searchProduct(productInfo: dict)
    }
    
    @objc func nextButtonClicked(_ sender: UIButton) {
        
        var currentCount = self.detailAdapter.currentProductIndex
        guard let totalCount = self.productsFromSearchResult?.data.count else {
            return
        }
        if currentCount == totalCount - 1 {
            return
        }
        currentCount = currentCount + 1
        labelCount = labelCount + 1
        
        self.countLabel?.text = String(labelCount) + " of " + String(self.productsFromSearchResult?.data.count ?? 0)
        
        self.detailAdapter.currentProductIndex = currentCount
        self.selectedProductIndex = currentCount
        fetchProductImages()
    }
    
    @objc func prevButtonClicked(_ sender: UIButton) {
        var currentCount = self.detailAdapter.currentProductIndex
        
        if currentCount <= 0 {
            return
        }
        currentCount = currentCount - 1
        labelCount = labelCount - 1
        self.countLabel?.text = String(labelCount) + " of " + String(self.productsFromSearchResult?.data.count ?? 0)
        
        self.detailAdapter.currentProductIndex = currentCount
        self.selectedProductIndex = currentCount
        fetchProductImages()
    }
    
//    func layoutTableHeaderView(images: [ProductImages]) {
//     
//        guard let headerView = self.detailTableView.tableHeaderView else { return }
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//         
//        //let headerWidth = headerView.bounds.size.height
//        let metricDict = ["viewHeight": images.count > 0 ? 294 : 100]
//        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView(viewHeight)]", metrics: metricDict, views: ["headerView": headerView])
//        
//        headerView.addConstraints(temporaryWidthConstraints)
//         
//        headerView.setNeedsLayout()
//        headerView.layoutIfNeeded()
//         
//        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//        let height = headerSize.height
//        var frame = headerView.frame
//         
//        frame.size.height = height
//        headerView.frame = frame
//         
//        self.detailTableView.tableHeaderView = headerView
//         
//        headerView.removeConstraints(temporaryWidthConstraints)
//        headerView.translatesAutoresizingMaskIntoConstraints = true
//    }
    
    func addNewOutfit(productInfo: ProductDetails) {
        let user = getLoggedInUser()
        var dict: [String: Any] = ["client_name": user?.client_name ?? "", "packshot_id": productInfo.data[0]._id ?? ""]
        self.detailPresenter.updateProductInfo(productInfo: dict)
    }
}

fileprivate extension ProductDetailViewController {
    
    func setupNavigationBar() {
        let nextButton = UIButton(type: .custom)
        nextButton.tag = 100
        //viewScanButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.frame = CGRect(x: UIScreen.main.bounds.size.width/2 + 20, y: 23, width: 40, height: 40)
        nextButton.setImage(UIImage(named: "next_icon"), for: .normal)
        nextButton.contentMode = .scaleAspectFit
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(nextButton)
        
        self.countLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/2 - 20, y: 31, width: 60, height: 20))
        self.countLabel?.font = UIFont.tofinoMediumTwelve()
        self.countLabel?.textColor = UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.4)
        self.navigationController?.navigationBar.addSubview(self.countLabel ?? UILabel())
        
        let prevButton = UIButton(type: .custom)
        prevButton.tag = 101
        prevButton.contentMode = .scaleAspectFit
        //viewScanButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - 60, y: 23, width: 40, height: 40)
        prevButton.setImage(UIImage(named: "prev_icon"), for: .normal)
        prevButton.addTarget(self, action: #selector(prevButtonClicked), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(prevButton)
    }
    
    func setupAdapter() {
        if self.detailAdapter == nil {
            self.detailAdapter = ProductDetailAdapter(tableView: self.detailTableView, delegate: self)
            self.detailTableView.dataSource = self.detailAdapter
            if let productDetail = self.productsFromSearchResult {
                self.detailAdapter.productDetail = productDetail
            }
        }
    }
    
    func setupPresenter() {
        if self.detailPresenter == nil {
            let interactor = ProductDetailInteractor(networkClient: NetworkingClient())
            self.detailPresenter = ProductDetailPresenter(detailInteractor: interactor, detailView: self)
        }
    }
}

extension ProductDetailViewController: ProductDetailAdapterDelegate {
    
    func showPhotoGallery() {
        // 1. create SKPhoto Array from UIImage
        var images = [SKPhoto]()
        
        let productData = self.detailAdapter.productDetail?.data[selectedProductIndex]
        if let imageList = productData?.images {
            for imageObj in imageList {
                let imageName = imageObj.image_name
                let urlStr = imageName
                let photo = SKPhoto.photoWithImageURL(urlStr)
                images.append(photo)
            }
        }
        
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        self.present(browser, animated: true, completion: {})
    }
    
    func showProductInfo() {
        let infoVC = ProductInfoViewController.instantiate(fromStoryboard: .Product)
        infoVC.productInfo = self.detailAdapter.productDetail?.data[selectedProductIndex]
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func showCopywrite() {
        let copywriteVC = CopywriteViewController.instantiate(fromStoryboard: .Product)
        
        if let product = self.detailAdapter.productDetail?.data[selectedProductIndex] {
            copywriteVC.copywriteObject = product.copywrite
        }
        
        self.navigationController?.pushViewController(copywriteVC, animated: true)
    }
    
    func didTapOnAddButton(sender: UIButton) {
        
        if let sectionId = ProductSections(rawValue: sender.tag) {
            switch sectionId {
            case .shopthelook:
                let scanVC = BarcodeReaderViewController()
                scanVC.barcodeOption = .outfit
                scanVC.outfitDelegate = self
                
                let navC = UINavigationController(rootViewController: scanVC)
                navC.navigationBar.tintColor = UIColor.white
                navC.navigationBar.barStyle = .black
                navC.modalPresentationStyle = .fullScreen
                self.present(navC, animated: true, completion: nil)
                print("new look")
            case .session:
                guard let product = self.detailAdapter.productDetail?.data[self.detailAdapter.currentProductIndex] else {
                    return
                }
                
                let session = product.sessions.max { (session1, session2) -> Bool in
                    session1.product_session_id < session2.product_session_id
                }
                if session?.scan_out_date.Value.isEmpty == true {
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    let alert = UIAlertController(title: "Message", message: "Product already have a live session", preferredStyle: .alert)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let addSessionVC = AddSessionViewController.instantiate(fromStoryboard: .Product)
                addSessionVC.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
                addSessionVC.productInfo = self.detailAdapter.productDetail?.data[selectedProductIndex]
                addSessionVC.delegate = self
                DispatchQueue.main.async {
                    self.present(addSessionVC, animated: true, completion: nil)
                }
                
            case .notes:
                let addNoteVC = AddNotesViewController.instantiate(fromStoryboard: .Product)
                addNoteVC.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
                addNoteVC.productInfo = self.detailAdapter.productDetail?.data[selectedProductIndex]
                addNoteVC.delegate = self
                DispatchQueue.main.async {
                    self.present(addNoteVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func didTapOnViewMoreButton(sender: UIButton) {
    
    }
    
    func didTapOnRow(indexPath: IndexPath) {
        if let sectionId = ProductSections(rawValue: indexPath.section) {
            
            if sectionId == .session {
                let productDetailVC = ScannedProductDetailViewController.instantiate(fromStoryboard: .Scan)
                productDetailVC.comingFromSession = true
                if let product = self.detailAdapter.productDetail?.data[selectedProductIndex] {
                    productDetailVC.sessionObject = product.sessions[indexPath.row]
                    productDetailVC.barcode = product.barcode
                }
                
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    }
    
    func showEditSessionScreen(atIndex: Int) {
        let editSessionVC = EditSessionViewController.instantiate(fromStoryboard: .Product)
        guard let product = self.detailAdapter.productDetail?.data[self.detailAdapter.currentProductIndex] else {
            return
        }
        
        let session = product.sessions.max { (session1, session2) -> Bool in
            session1.product_session_id < session2.product_session_id
        }
        editSessionVC.oldSessionObject = session
        editSessionVC.product = product
        editSessionVC.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(editSessionVC, animated: true)
        }
    }
}

extension ProductDetailViewController: ProductPageDetailView {
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
    
    func addedNewOutfit(message: String, code: Int) {
        if let product = self.productsFromSearchResult?.data[selectedProductIndex] {
            getUpdatedProduct(pid: product._id)
        }
    }
    
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int) {
        print(productDetail)
        DispatchQueue.main.async {
            if self.productId.isEmpty {
                if let data = productDetail.data.first {
                    if (self.productsFromSearchResult?.data.count)! > self.selectedProductIndex {
                        self.productsFromSearchResult?.data[self.selectedProductIndex] = data
                        self.detailAdapter.productDetail = self.productsFromSearchResult
                    }
                }
            }
            else {
                self.detailAdapter.productDetail = productDetail
                self.productsFromSearchResult = productDetail
            }
        }
    }
    
    func productImages(productImages: [ProductImages], message: String, code: Int) {
        print(productImages.count)
        guard let adapter = self.detailAdapter else {
            return
        }
        if adapter.productDetail?.data.count ?? 0 > selectedProductIndex {
            //self.layoutTableHeaderView(images: productImages)
            self.detailAdapter.productDetail?.data[selectedProductIndex].images = productImages
            if let headerView = self.detailTableView.tableHeaderView as? DetailHeaderView {
                headerView.productData = self.detailAdapter.productDetail?.data[selectedProductIndex]
            }
        }
    }
}

extension ProductDetailViewController: AddSessionViewDelegate {
    func updateProductPage() {
        if let product = self.productsFromSearchResult?.data[selectedProductIndex] {
            getUpdatedProduct(pid: product._id)
        }
    }
}

extension ProductDetailViewController: EditSessionViewDelegate {
    func updateProductPageFromSessionEdit() {
        if let product = self.productsFromSearchResult?.data[selectedProductIndex] {
            getUpdatedProduct(pid: product._id)
        }
    }
}

extension ProductDetailViewController: ProductDetailViewControllerDelegate {
    
    func productDetailForOutfit(product: ProductDetails) {
        addNewOutfit(productInfo: product)
    }
}

extension UITableView {
 
    //Variable-height UITableView tableHeaderView with autolayout
    
}
