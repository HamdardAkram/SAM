//
//  AddSessionPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol AddSessionPresenterProtocol {
    func addNewSession(productInfo: [String: Any])
}

class AddSessionPresenter: AddSessionPresenterProtocol {
    fileprivate let sessionInteractor: AddSessionInteractorProtocol
    fileprivate weak var sessionView: AddSessionView?
        
    
    
    init(sessionInteractor: AddSessionInteractorProtocol, sessionView: AddSessionView) {
        self.sessionInteractor = sessionInteractor
        self.sessionView = sessionView
    }
    
    func addNewSession(productInfo: [String: Any]) {
        
        self.sessionView?.showActivityIndicator(withMessage: "Updating..")
        self.sessionInteractor.addNewSession(productInfo: productInfo, success: { (productDetail, code) in
            
            self.sessionView?.newSessionCreated(productInfo: productDetail, message: "", code: 0)
            self.sessionView?.hideActivityIndicator()
        }) { (error) in
            
            self.sessionView?.hideActivityIndicator()
            self.sessionView?.showError(error: error)
        }
    }
}
