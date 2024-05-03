//
//  AccountDetailViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AccountDetailView: BaseProtocol {

    func passwordUpdated(message: String)
}


class AccountDetailViewController: BaseViewController {
    
    @IBOutlet weak var accountDetailTableView: UITableView!
    
    fileprivate var accountDetailAdapter: AccountDetailAdapter!
    fileprivate var accountDetailPresenter: AccountDetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("ACCOUNT_DETAIL", comment: "")
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = UIColor.samRed()
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        setupAdapter()
        setupPresenter()
    }
    
    @objc func saveButtonClicked() {
        
        let newPassword = self.accountDetailAdapter.dataSource[3]["value"]
        let confirmPass = self.accountDetailAdapter.dataSource[4]["value"]
        
        if newPassword!.count <= 0 {
            self.showOkAlert(NSLocalizedString("Please enter new password", comment: ""))
            return
        }
        
        if newPassword != confirmPass {
            self.showOkAlert(NSLocalizedString("Password do not match", comment: ""))
            return
        }
        
        let user = getLoggedInUser()
        if let userpass = user?.data?.user_pass {
            let newPassword = self.accountDetailAdapter.dataSource[3]["value"]?.md5 ?? ""
            let dict: [String: String] = ["user_old_pass": userpass, "user_pass": newPassword, "client": user?.client_name ?? "", "email": user?.data?.email ?? ""]
            self.accountDetailPresenter.updatePassword(withUserInfo: dict)
        }
    }
}

fileprivate extension AccountDetailViewController {
    func setupAdapter() {
        self.accountDetailAdapter = AccountDetailAdapter(tableView: self.accountDetailTableView, delegate: self)
        self.accountDetailTableView.dataSource = self.accountDetailAdapter
    }
    
    func setupPresenter() {
        let interactor = AccountDetailInteractor(networkClient: NetworkingClient())
        self.accountDetailPresenter = AccountDetailPresenter(accountDetailInteractor: interactor, accountDetailView: self)
    }
}

extension AccountDetailViewController: AccountDetailCellDelegate {
    func updateAccountDetail(textField: UITextField, forCell: AccountDetailCell) {
        //self.editSessionAdapter.sessionObject?.scan_in_date = VariacType.double(date)
        var dict = self.accountDetailAdapter.dataSource[forCell.tag]
        dict["value"] = textField.text
        self.accountDetailAdapter.dataSource[forCell.tag] = dict
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        
    }
}

extension AccountDetailViewController: AccountDetailView {
    
    func showActivityIndicator(withMessage message: String) {
        self.accountDetailTableView.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.accountDetailTableView.hideLoading()
    }
    
    func passwordUpdated(message: String) {
        self.showOkAlert(NSLocalizedString(message, comment: ""))
    }
}

extension AccountDetailViewController: AccountDetailAdapterDelegate {
    
    func textFieldEndEditing(textField: CustomTextField) {
        
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        //self.selectedTextField = textField
    }
}

