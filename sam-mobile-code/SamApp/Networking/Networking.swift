//
//  Networking.swift
//  SamApp
//
//  Created by Akram on 12/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias SuccessHandler = (Data?, JSON?) -> ()
typealias ErrorHandler = (Error) -> ()

protocol Networking {
    func send(path: String, method: HTTPMethod, params: [String: Any], success: @escaping SuccessHandler, failure: @escaping ErrorHandler)
    func sendDataWithArray(path: String, method: HTTPMethod, params: [String: Any], success: @escaping SuccessHandler, failure: @escaping ErrorHandler)
}

