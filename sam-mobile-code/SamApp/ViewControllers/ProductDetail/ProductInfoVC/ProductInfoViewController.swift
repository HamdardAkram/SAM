//
//  ProductInfoViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductInfoView: BaseProtocol {
    func productUpdated(productInfo: ProductDetails, message: String, code: Int)
}

class ProductInfoViewController: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    fileprivate var infoAdapter: ProductInfoAdapter!
    fileprivate var infoPresenter: ProductInfoPresenterProtocol!
    
    var productInfo: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("PRODUCT_INFO", comment: "")
        
        guard let productPageActions = getProductPageActionItems() else {
            return
        }
        
        if productPageActions.contains("edit_product") {
            let selectButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
            selectButton.tintColor = UIColor.samRed()
            
            self.navigationItem.rightBarButtonItem = selectButton
        }
        setupAdapter()
        setupPresenter()
    }

    @objc func editButtonClicked() {
        let title = self.navigationItem.rightBarButtonItem?.title
        if title == "Edit" {
            self.navigationItem.rightBarButtonItem?.title = "Save"
            self.infoAdapter.isEditingOn = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.infoAdapter.isEditingOn = false
            
            let user = getLoggedInUser()
            var dict: [String: Any] = ["client_name": user?.client_name ?? "", "packshot_id": self.productInfo?._id ?? ""]
            guard let attributes = user?.productAttributes else {
                return
            }
            for attribute in attributes {
                //self.dataSource.append(["title": str.capitalized])
                dict[attribute] = self.infoAdapter.productInfo?.productInfo[attribute]?.Value ?? ""
            }
            self.infoPresenter.updateProductInfo(productInfo: dict)
        }
    }
}

fileprivate extension ProductInfoViewController {
    
    func setupAdapter() {
        self.infoAdapter = ProductInfoAdapter(tableView: self.infoTableView, delegate: self)
        self.infoTableView.dataSource = self.infoAdapter
        self.infoAdapter.productInfo = self.productInfo
    }
    
    func setupPresenter() {
        let interactor = ProductInfoInteractor(networkClient: NetworkingClient())
        self.infoPresenter = ProductInfoPresenter(infoInteractor: interactor, infoView: self)
    }
}

extension ProductInfoViewController: ProductInfoAdapterDelegate {
    
}

extension ProductInfoViewController: ProductInfoView {
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
    
    func productUpdated(productInfo: ProductDetails, message: String, code: Int) {
        //self.delegate?.updateProductPageFromSessionEdit()
        
        self.showOkAlert(message)
        
    }
}

extension ProductInfoViewController: ProductInfoCellDelegate {
    func updateProductInfo(textField: CustomTextField, forCell: ProductInfoCell) {
        self.infoAdapter.productInfo?.productInfo[textField.identifier ?? ""] = VariacType.string(textField.text ?? "")
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        
    }
}
