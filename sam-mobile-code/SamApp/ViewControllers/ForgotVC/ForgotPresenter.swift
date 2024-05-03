//
//  ForgotPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 17/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ForgotPresenterProtocol {
    func resetPassword(withUserInfo: [String: String])
    func updatePassword(withUserInfo: [String: String])
}

class ForgotPresenter: ForgotPresenterProtocol {
    
    fileprivate let forgotInteractor: ForgotInteractorProtocol
    fileprivate weak var forgotView: ForgotView?
        
    init(forgotInteractor: ForgotInteractorProtocol, forgotView: ForgotView) {
        self.forgotInteractor = forgotInteractor
        self.forgotView = forgotView
    }
    
    func resetPassword(withUserInfo: [String: String]) {
        
        self.forgotView?.showActivityIndicator(withMessage: "resetting password..")
        self.forgotInteractor.resetPassword(withUserInfo: withUserInfo, success: { (json) in
            
            self.forgotView?.resetRequsetDone(json: json)
            self.forgotView?.hideActivityIndicator()
        }) { (error) in
            
            self.forgotView?.hideActivityIndicator()
            self.forgotView?.showError(error: error)
        }
    }
    
    func updatePassword(withUserInfo: [String: String]) {
            
            self.forgotView?.showActivityIndicator(withMessage: "updating new password..")
            self.forgotInteractor.updatePassword(withUserInfo: withUserInfo, success: { (json) in
                
                self.forgotView?.updatePasswordDone(json: json)
                self.forgotView?.hideActivityIndicator()
            }) { (error) in
                
                self.forgotView?.hideActivityIndicator()
                self.forgotView?.showError(error: error)
            }
        }
}
