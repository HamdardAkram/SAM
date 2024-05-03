//
//  AccountDetailPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AccountDetailPresenterProtocol {
    func updatePassword(withUserInfo: [String: String])
}

class AccountDetailPresenter: AccountDetailPresenterProtocol {
    fileprivate let accountDetailInteractor: AccountDetailInteractorProtocol
    fileprivate weak var accountDetailView: AccountDetailView?
        
    init(accountDetailInteractor: AccountDetailInteractorProtocol, accountDetailView: AccountDetailView) {
        self.accountDetailInteractor = accountDetailInteractor
        self.accountDetailView = accountDetailView
    }
    
    func updatePassword(withUserInfo: [String: String]) {
        
        self.accountDetailView?.showActivityIndicator(withMessage: "Updating...")
        self.accountDetailInteractor.updatePassword(withUserInfo: withUserInfo, success: { (message, code) in
            
            self.accountDetailView?.passwordUpdated(message: message)
            self.accountDetailView?.hideActivityIndicator()
        }) { (error) in
            
            self.accountDetailView?.hideActivityIndicator()
            self.accountDetailView?.showError(error: error)
        }
    }
}
