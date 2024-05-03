//
//  AddSessionViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 06/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AddSessionView: BaseProtocol {
    func newSessionCreated(productInfo: ProductDetails, message: String, code: Int)
}

protocol AddSessionViewDelegate: class {
    func updateProductPage()
}

class AddSessionViewController: BaseModalViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var sessionTableView: UITableView!
    fileprivate var addSessionAdapter: AddSessionAdapter!
    fileprivate var sessionPresenter: AddSessionPresenterProtocol!
    
    weak var delegate:AddSessionViewDelegate?
    var productInfo: ProductData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("ADD_SESSION", comment: "")
        let selectButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        selectButton.tintColor = UIColor.samRed()
        self.navigationItem.rightBarButtonItem = selectButton
        
        setupAdapter()
        setupPresenter()
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewOnTap(tapGesture:)))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func saveButtonClicked() {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.view)
        if self.sessionTableView.frame.contains(touchPoint) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func dismissViewOnTap(tapGesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension AddSessionViewController {
    
    func setupAdapter() {
        self.addSessionAdapter = AddSessionAdapter(tableView: self.sessionTableView, delegate: self)
        self.sessionTableView.dataSource = self.addSessionAdapter
    }
    
    func setupPresenter() {
        let interactor = AddSessionInteractor(networkClient: NetworkingClient())
        self.sessionPresenter = AddSessionPresenter(sessionInteractor: interactor, sessionView: self)
    }
}

extension AddSessionViewController: AddSessionAdapterDelegate {
    
    func addSessionClicked() {
        
        guard let productId = self.productInfo?._id else {
            return
        }
        
        let user = getLoggedInUser()
        let dict = ["product_id": productId, "session_billable": self.addSessionAdapter.billable, "session_sla": self.addSessionAdapter.sla, "user_name": user?.data?.full_name ?? "", "client_name": user?.client_name ?? ""]
        
        self.sessionPresenter.addNewSession(productInfo: dict)
    }
    
    func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddSessionViewController: AddSessionView {
    func newSessionCreated(productInfo: ProductDetails, message: String, code: Int) {
        self.delegate?.updateProductPage()
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
}
