//
//  SignInInteractor.swift
//  
//
//  Created by Muhammad Akram on 12/09/19.
//

import Foundation

typealias SignInInteractorSuccessHandler = (User, Int) -> ()
typealias SignInInteractorFailureHandler = (Error) -> ()

protocol SignInInteractorProtocol {
    func signin(withUserInfo: [String: Any], success: @escaping SignInInteractorSuccessHandler, failure: @escaping SignInInteractorFailureHandler)
}

enum SignInError: LocalizedError {
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


class SignInInteractor: SignInInteractorProtocol {
    
    fileprivate let networkClient: Networking
        
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func signin(withUserInfo: [String: Any], success: @escaping SignInInteractorSuccessHandler, failure: @escaping SignInInteractorFailureHandler) {
        
        self.networkClient.sendDataWithArray(path: "api/login/login", method: .post, params: withUserInfo, success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from:
                    data!)
                print(user)
                if user.statusCode == 200 {
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(user) {
                        let defaults = UserDefaults.standard
                        defaults.set(encoded, forKey: LOGGEDIN_USER)
                        defaults.synchronize()
                    }
                }
                success(user, 1)
            } catch let parsingError {
                print("Error", parsingError)
                failure(parsingError)
            }
            
        }) { (error) in
            failure(error)
        }
    }
}
