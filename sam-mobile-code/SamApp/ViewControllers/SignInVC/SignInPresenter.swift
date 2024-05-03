//
//  SignInPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 12/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol SignInPresenterProtocol {
    func signin(withUserInfo: [String: String])
}

class SignInPresenter: SignInPresenterProtocol {
    
    fileprivate let signInInteractor: SignInInteractorProtocol
    fileprivate weak var signInView: SignInView?
        
    init(signInInteractor: SignInInteractorProtocol, signInView: SignInView) {
        self.signInInteractor = signInInteractor
        self.signInView = signInView
    }
    
    func signin(withUserInfo: [String: String]) {
        
        self.signInView?.showActivityIndicator(withMessage: "Logging..")
        self.signInInteractor.signin(withUserInfo: withUserInfo, success: { (user, code) in
            
            self.signInView?.signInDone(user: user)
            self.signInView?.hideActivityIndicator()
        }) { (error) in
            
            self.signInView?.hideActivityIndicator()
            self.signInView?.showError(error: error)
        }
    }
}
