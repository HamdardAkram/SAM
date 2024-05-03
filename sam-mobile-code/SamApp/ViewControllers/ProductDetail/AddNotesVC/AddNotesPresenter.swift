//
//  AddNotesPresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

protocol AddNotesPresenterProtocol {
    func getExistingNote(productInfo: [String: Any])
    func addNewNote(productInfo: [String: Any])
}

class AddNotesPresenter: AddNotesPresenterProtocol {
    fileprivate let notesInteractor: AddNotesInteractorProtocol
    fileprivate weak var notesView: AddNotesView?
        
    
    
    init(notesInteractor: AddNotesInteractorProtocol, notesView: AddNotesView) {
        self.notesInteractor = notesInteractor
        self.notesView = notesView
    }
    
    func getExistingNote(productInfo: [String: Any]) {
        
        self.notesView?.showActivityIndicator(withMessage: "Updating..")
        self.notesInteractor.getExistingNotes(productInfo: productInfo, success: { (productDetail, code) in
            
            self.notesView?.fetchExistingNotes(productInfo: productDetail, message: "", code: 0)
            self.notesView?.hideActivityIndicator()
        }) { (error) in
            
            self.notesView?.hideActivityIndicator()
            self.notesView?.showError(error: error)
        }
    }
    
    func addNewNote(productInfo: [String: Any]) {
        
        self.notesView?.showActivityIndicator(withMessage: "Updating..")
        self.notesInteractor.addNewNote(productInfo: productInfo, success: { (productDetail, code) in
            
            self.notesView?.newNoteCreated(productInfo: productDetail, message: "", code: 0)
            self.notesView?.hideActivityIndicator()
        }) { (error) in
            
            self.notesView?.hideActivityIndicator()
            self.notesView?.showError(error: error)
        }
    }
}
