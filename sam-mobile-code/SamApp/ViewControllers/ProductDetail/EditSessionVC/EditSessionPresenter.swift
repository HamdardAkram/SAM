//
//  EditSessionPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 03/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol EditSessionPresenterProtocol {
    func editSession(productInfo: [String: Any])
}

class EditSessionPresenter: EditSessionPresenterProtocol {
    fileprivate let editSessionInteractor: EditSessionInteractorProtocol
    fileprivate weak var editSessionView: EditSessionView?
        
    
    
    init(editSessionInteractor: EditSessionInteractorProtocol, editSessionView: EditSessionView) {
        self.editSessionInteractor = editSessionInteractor
        self.editSessionView = editSessionView
    }
    
    func editSession(productInfo: [String: Any]) {
        
        self.editSessionView?.showActivityIndicator(withMessage: "Updating..")
        self.editSessionInteractor.editSession(productInfo: productInfo, success: { (productDetail, code) in
            
            self.editSessionView?.sessionEdited(productInfo: productDetail, message: "", code: 0)
            self.editSessionView?.hideActivityIndicator()
        }) { (error) in
            
            self.editSessionView?.hideActivityIndicator()
            self.editSessionView?.showError(error: error)
        }
    }
}
