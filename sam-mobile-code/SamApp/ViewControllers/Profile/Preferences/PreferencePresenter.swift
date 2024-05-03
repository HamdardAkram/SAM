//
//  PreferencePresenter.swift
//  SamApp
//
//  Created by Muhammad Akram on 10/02/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import Foundation

protocol PreferencePresenterProtocol {
    func getModelManagerPreferences(search: String, client: String)
}

class PreferencePresenter: PreferencePresenterProtocol {
    
    fileprivate let preferenceInteractor: PreferenceInteractorProtocol
    fileprivate weak var prefsResultView: PreferencesView?
    
    init(preferenceInteractor: PreferenceInteractorProtocol, prefsResultView: PreferencesView) {
        self.preferenceInteractor = preferenceInteractor
        self.prefsResultView = prefsResultView
    }
    
    func getModelManagerPreferences(search: String, client: String) {
        prefsResultView?.showLoading(withMessage: "Fetching...")
        preferenceInteractor.getModelManagerPreferences(search: search, client: client) { prefs, state in
            self.prefsResultView?.hideLoading()
            self.prefsResultView?.managerPreferences(prefs: prefs, message: "success")
        } failure: { error in
            self.prefsResultView?.hideLoading()
            print(error)
        }
    }
}
