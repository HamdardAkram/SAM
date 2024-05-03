//
//  NetworkingClient.swift
//  SamApp
//
//  Created by Akram on 12/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//""//"http://10.0.14.200:81/index.php/"//
fileprivate var BaseURL = "https://mobile.sam3.com/index.php/"//"http://api.packshot.local/sam/index.php/"

fileprivate var APIKey = "dhjshajhsgdjhdyehsycbhsk24ianshte920@1"

var ImageURL = "https://studio.sam3.com/images/"

class NetworkingClient: Networking {
    
    func send(path: String, method: HTTPMethod, params: [String: Any], success: @escaping SuccessHandler, failure: @escaping ErrorHandler) {
        
        self.send(url: BaseURL + path,
                  method: method,
                  params: params,
                  success: success,
                  failure: failure)
    }
    
    func send(url: String, method: HTTPMethod, params: [String: Any], success: @escaping SuccessHandler, failure: @escaping ErrorHandler) {
        
        let defaults = UserDefaults.standard
//        if let dict = defaults.value(forKey: REGISTRATION) as? [String: Any] {
//            APIKey = dict["userToken"] as! String
//        }
        
        //let headers: HTTPHeaders = ["Content-Type": "text/plain", "X-API-KEY": //"88c550b2-5aac-4082-a970-f8e1d858c319@Pac"]
        
        AF.request(url, method: method, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    success(response.data, JSON(data))
                case .failure(let error):
                    failure(error)
                }
        }
    }
    
    func sendDataWithArray(path: String, method: HTTPMethod, params: [String: Any], success: @escaping SuccessHandler, failure: @escaping ErrorHandler) {
        
        let defaults = UserDefaults.standard
//        if let dict = defaults.value(forKey: REGISTRATION) as? [String: Any] {
//            APIKey = dict["userToken"] as! String
//        }
        let url = BaseURL + path
                
        var request = URLRequest(url: URL(string: url)!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("88c550b2-5aac-4082-a970-f8e1d858c319@Pac", forHTTPHeaderField: "X-API-KEY")
        switch method {
            case .get:
                request.httpMethod =  "GET"
            case .post:
                request.httpMethod =  "POST"
            case .delete:
                request.httpMethod =  "DELETE"
            case .put:
                request.httpMethod =  "PUT"
            case .patch:
                request.httpMethod =  "PATCH"
            case .connect:
                request.httpMethod =  "CONNECT"
            default: break
        }
        
        if let accessToken = UserDefaults.authToken {
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "customKey")
        }
        if path.contains("get_daily_token") {
            print("get_daily_token")
        }
        else {
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
            let json = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            print(json)
            request.httpBody = jsonData
        }
        
        AF.request(request).responseJSON { (response) in
                        switch response.result {
                        case .success(let data):
                            success(response.data, JSON(data))
                        case .failure(let error):
                            failure(error)
                        }
                }
    }
}

