//
//  ScanViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 16/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    @IBOutlet weak var scanCollectionView: UICollectionView!
    @IBOutlet weak var scanButton: UIButton!
    
    fileprivate var scanAdapter: ScanAdapter!
    fileprivate var scanPresenter: ScanPresenterProtocol!
    
    var productsToBeScanned: [ProductDetails] = []
    var barcodeOption: BarcodeOptions = .scanProductIn
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("SCAN_PRODUCT", comment: "")
        
        let selectButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllButtonClicked))
        selectButton.tintColor = UIColor.samRed()
        
        self.navigationItem.rightBarButtonItem = selectButton
        
        self.scanButton.clipsToBounds = true
        self.scanButton.layer.cornerRadius = 22.0
        
        setupAdapter()
        setupPresenter()
        
        for product in productsToBeScanned {
            product.toBeScanned = true
        }
        self.scanAdapter.dataSource = productsToBeScanned
    }
    
    @objc func selectAllButtonClicked() {
        for product in productsToBeScanned {
            product.toBeScanned = true
        }
        self.scanAdapter.dataSource = productsToBeScanned
    }
    
    @IBAction func onScanButtonClick(_ sender: Any) {
        
        let filteredProducts = productsToBeScanned.filter({ (product) -> Bool in
            return (product.toBeScanned == true)
        })
        if filteredProducts.count == 0 {
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            
            let alert = UIAlertController(title: "Message", message: "Please select atleast one product to scan", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        var ids: [String] = []
        
        for product in productsToBeScanned {
            let data = product.data[0]
            ids.append(data._id)
        }
        
        var dict: [String: Any] = [:]
        let user = getLoggedInUser()
        switch barcodeOption {
            case .scanProductIn:
                dict = ["client_name": user?.client_name ?? "", "productIds": ids, "user_name":user?.data?.full_name ?? "", "location": user?.data?.location ?? ""] as [String : Any]
                self.scanPresenter.scanProductsIn(productInfo: dict)
            case .scanProductOut:
                dict = ["client_name": user?.client_name ?? "", "productIds": ids, "user_name": user?.data?.full_name ?? ""] as [String : Any]
                self.scanPresenter.scanProductsOut(productInfo: dict)
            case .scanProductToSetStatus:
                self.scanPresenter.scanProductsIn(productInfo: dict)
            case .nonProductionScanIn:
                dict = ["client_name": user?.client_name ?? "", "productIds": ids, "user_name": user?.data?.full_name ?? ""] as [String : Any]
                self.scanPresenter.scanNonProductionScanIn(productInfo: dict)
            case .wardrobeScanIn:
                dict = ["client_name": user?.client_name ?? "", "productIds": ids, "user_name": user?.data?.full_name ?? ""] as [String : Any]
                self.scanPresenter.scanWardrobeProductsIn(productInfo: dict)
            case .wardrobeScanOut:
                dict = ["client_name": user?.client_name ?? "", "productIds": ids, "user_name": user?.data?.full_name ?? ""] as [String : Any]
                self.scanPresenter.scanWardrobeProductsOut(productInfo: dict)
            default:
                print("end")
        }
    }
}

fileprivate extension ScanViewController {
    func setupAdapter() {
        self.scanAdapter = ScanAdapter(collectionView: self.scanCollectionView, delegate: self)
        self.scanCollectionView.dataSource = self.scanAdapter
    }
    
    func setupPresenter() {
       let interactor = ScanInteractor(networkClient: NetworkingClient())
       self.scanPresenter = ScanPresenter(scanInteractor: interactor, scanView: self)
    }
}

extension ScanViewController: ScanView {
    
    func scanProductStatus(message: String, code: Int) {
        
        DispatchQueue.main.async {
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.performSegue(withIdentifier: "unwindToBarcode", sender: self)
            }
            
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
}

extension ScanViewController: ScanAdapterDelegate {
    func didTapOnRow(indexPath: IndexPath) {
//        let productDetailVC = ScannedProductDetailViewController.instantiate(fromStoryboard: .Scan)
//        if productsToBeScanned.count > indexPath.row {
//            let product = productsToBeScanned[indexPath.row]
//            if product.data.count > 0 {
//                productDetailVC.productId = product.data[0]._id
//            }
//        }
//        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
