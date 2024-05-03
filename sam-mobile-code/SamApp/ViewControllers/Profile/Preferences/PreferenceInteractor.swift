//
//  PreferenceInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 10/02/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import Foundation

typealias PreferenceInteractorSuccessHandler = (ModelManagerPreference, Int) -> ()
typealias PreferenceInteractorFailureHandler = (Error) -> ()


protocol PreferenceInteractorProtocol {
    func getModelManagerPreferences(search: String, client: String, success: @escaping PreferenceInteractorSuccessHandler, failure: @escaping PreferenceInteractorFailureHandler)
}

class PreferenceInteractor: PreferenceInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func getModelManagerPreferences(search: String, client: String, success: @escaping PreferenceInteractorSuccessHandler, failure: @escaping PreferenceInteractorFailureHandler) {
        
        let dict = ["search": search, "client": client]
        self.networkClient.sendDataWithArray(path: "api/modelsManager/listModelSetPreference", method: .post, params: dict, success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let preferences = try decoder.decode(ModelManagerPreference.self, from:
                    data!)
                print(preferences)
                
                success(preferences, 1)
            } catch let parsingError {
                print("Error", parsingError)
                failure(parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
    }
}
