//
//  RegisterPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 18/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol RegisterPresenterProtocol {
    func register(withUserInfo: [String: Any])
}

class RegisterPresenter: RegisterPresenterProtocol {
    
    fileprivate let registerInteractor: RegisterInteractorProtocol
    fileprivate weak var registerView: RegisterView?
        
    init(registerInteractor: RegisterInteractorProtocol, registerView: RegisterView) {
        self.registerInteractor = registerInteractor
        self.registerView = registerView
    }
    
    func register(withUserInfo: [String: Any]) {
        
        self.registerView?.showActivityIndicator(withMessage: "resetting password..")
        self.registerInteractor.register(withUserInfo: withUserInfo, success: { (json) in
            self.registerView?.userRegistered(apiKey: "", message: "", code: 0)
            self.registerView?.hideActivityIndicator()
        }) { (error) in
            
            self.registerView?.hideActivityIndicator()
            self.registerView?.showError(error: error)
        }
    }
}
