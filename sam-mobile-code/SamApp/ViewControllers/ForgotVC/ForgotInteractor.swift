//
//  ForgotInteractor.swift
//  SamApp
//
//  Created by Muhammad Akram on 17/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ForgotInteractorSuccessHandler = (JSON?) -> ()
typealias ForgotInteractorFailureHandler = (Error) -> ()

protocol ForgotInteractorProtocol {
    func resetPassword(withUserInfo: [String: Any], success: @escaping ForgotInteractorSuccessHandler, failure: @escaping ForgotInteractorFailureHandler)
    func updatePassword(withUserInfo: [String: Any], success: @escaping ForgotInteractorSuccessHandler, failure: @escaping ForgotInteractorFailureHandler)
}

enum ForgotError: LocalizedError {
    case incorrectpassword(String)
    case notAuthorized(String)
    case inCorrectData(String)
    public var errorDescription: String? {
       switch self {
       case .incorrectpassword:
           return NSLocalizedString("Password is incorrect.", comment: "My error")
       case .notAuthorized(_):
            return NSLocalizedString("User is not authorized.", comment: "My error")
       case .inCorrectData(_):
            return NSLocalizedString("Incorrect input data.", comment: "My error")
        }
   }
}


class ForgotInteractor: ForgotInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func resetPassword(withUserInfo: [String: Any], success: @escaping ForgotInteractorSuccessHandler, failure: @escaping ForgotInteractorFailureHandler) {
    
        self.networkClient.sendDataWithArray(path: "api/login/resetpassword", method: .post, params: withUserInfo, success: { (data, json) in
            
            success(json)
            
        }) { (error) in
            failure(error)
        }
    }
    
    func updatePassword(withUserInfo: [String: Any], success: @escaping ForgotInteractorSuccessHandler, failure: @escaping ForgotInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/login/resetpassword", method: .post, params: withUserInfo, success: { (data, json) in
                    
        success(json)
            
        }) { (error) in
            failure(error)
        }
    }
}
