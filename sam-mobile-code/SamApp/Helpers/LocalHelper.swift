//
//  LocalHelper.swift
//  SamApp
//
//  Created by Akram on 08/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Constant {
    static let APPNAME              = "SamApp"
    static let kBASEURL             = ""
}

//MARK: *************** Global Helper Method ***************

func setUserDefault(_ key:String,value:String) {
    let defaults = UserDefaults.standard
    defaults.set(value, forKey: key)
}

func getUserDefault(_ key:String) ->String {
    let defaults = UserDefaults.standard
    let val = defaults.string(forKey: key)
    guard let valueForKey = val else {
        return ""
    }
    return valueForKey
}

func removeUserDefault(_ key:String) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key)
}

func getLoggedInUser() -> User? {
    let defaults = UserDefaults.standard
    let data = defaults.data(forKey: LOGGEDIN_USER)
    let decoder = JSONDecoder()
    
    guard let userdata = data else {
        return nil
    }
    if let user = try? decoder.decode(User.self, from: userdata) {
        return user
    }
    return nil
}

func getProductPageActionItems() -> [String]? {
    let user = getLoggedInUser()
    let userRights = user?.user_rights[0]
    let actionItems = userRights?.action_items
    guard let productPageActions = actionItems?["single_product_page"] else {
        return nil
    }
    return productPageActions
}

func convertDate(date: String) -> String {
    var dateStr = ""
    if let dateNum = Double(date) {
        let date = Date(timeIntervalSince1970: dateNum)
        dateStr = AppDelegate.formatter.string(from: date)
    }
    return dateStr
}

class LocalHelper: NSObject {
    
    static let shared = LocalHelper()
    
    func fetchConfig() {
        let networkClient = NetworkingClient()
        
        networkClient.sendDataWithArray(path: "api/mobile/appVersion", method: .post, params: [:], success: { (data, json) in
            
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = jsonObj as? [String: Any] {
                    
                    let defaults = UserDefaults.standard
                    defaults.set(object, forKey: CONFIGURATION)
                    defaults.synchronize()
                    
                    print(object)
                }
            } catch {
                
            }
            
        }) { (error) in
            print("fail")
        }
    }
    
    func fetchToken() {
        let networkClient = NetworkingClient()
        
        networkClient.sendDataWithArray(path: "api/JWTController/get_daily_token", method: .get, params: [:], success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from:
                    data!)
                print("Token Response = ", tokenResponse)
                UserDefaults.authToken = tokenResponse.token
                UserDefaults.standard.synchronize()
            } catch {
                
            }
            
        }) { (error) in
            print("fail")
        }
    }
    
    func verifyOTP(mobile: String, otp: String, success: @escaping SuccessHandler, failure: @escaping ErrorHandler) {
        let headers = ["content-type": "application/json"]
        let strURL = String(format:"https://api.msg91.com/api/v5/otp/verify?otp=%@authkey=309083AVItwBVS4oti5dfb66e3P1&mobile=%@", otp, mobile)
        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
              if (error == nil) {
                //print(error)
                success(data, JSON(data))
              } else {
                //let httpResponse = response as? HTTPURLResponse
                failure(error!)
              }
            })

        dataTask.resume()
    }
    
    
    func sendOTP(toMobile: String, success: @escaping SuccessHandler, failure: @escaping ErrorHandler) {
        let headers = ["content-type": "application/json"]

        let strURL = String(format: "https://api.msg91.com/api/v5/otp?authkey=309083AVItwBVS4oti5dfb66e3P1&mobile=%@&template_id=5dfb6ac3d6fc0503c1065aa9", toMobile)
        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error == nil) {
            //print(error)
            success(data, JSON(data))
          } else {
            //var errorTemp = Error(domain:"", code: response.statusCode, userInfo:nil)
            failure(error!)
          }
        })

        dataTask.resume()
    }
    
    func searchKeyForAttribute(key: String) -> String {
        let str = key.replacingOccurrences(of: " ", with: "_")
        return str.lowercased()
    }
    
    func searchParameterDict(sectionItems: [RefineSection], startOffset: Int, limit: Int) -> [String: Any] {
        
        var search_dict = [String: Any]()
        let section1 = sectionItems[0]
        for (index, item) in section1.items.enumerated() {
            if item.itemValue.isEmpty == false {
                search_dict[searchKeyForAttribute(key: item.itemName)] = item.itemValue
            }
        }
        
        let section2 = sectionItems[1]
        for (index, item) in section2.items.enumerated() {
            if item.itemValue.isEmpty == false {
                
                if item.itemName == "Select Date Type" {
                    search_dict["date_search"] = getDateType(value: item.itemValue)
                }
                else {
                    search_dict[searchKeyForIndex(index: index, section: 1)] = item.itemValue
                }
            }
        }
        var fromDateSec = 0.0
        var toDateSec = 0.0
        if let fromDate = section2.fromDate {
            fromDateSec = fromDate.timeIntervalSince1970
        }
        if let toDate = section2.toDate {
            toDateSec = toDate.timeIntervalSince1970
        }
        
        let section3 = sectionItems[2]
        for (index, item) in section3.items.enumerated() {
            if item.itemValue.isEmpty == false {
                search_dict[searchKeyForIndex(index: index, section: 2)] = item.itemValue
            }
        }
        
        search_dict["from_date"] = fromDateSec
        search_dict["to_date"] = toDateSec
        search_dict.removeValue(forKey: "")
        let user = getLoggedInUser()
        let dict = ["client_name": user?.client_name ?? "", "skip": startOffset, "limit": limit, "search": search_dict] as [String : Any]
        return dict
    }
    
    func searchKeyForIndex(index: Int, section: Int) -> String {
        switch section {
            case 0:
                switch index {
                    case 0:
                        return SEARCH_SKU
                    case 1:
                        return SEARCH_BARCODE
                    case 2:
                        return SEARCH_PRODUCT_TYPE
                    case 3:
                        return SEARCH_CATEGORY
                    case 4:
                        return SEARCH_BRAND
                    case 5:
                        return SEARCH_COLOR
                    case 6:
                        return SEARCH_NOTES
                    case 7:
                        return SEARCH_STATUS
                    case 8:
                        return SEARCH_PRIORITY
                    case 9:
                        return SEARCH_SESSION_ID
                    default:
                        print("end")
                }
            case 1:
                switch index {
                case 0:
                    return SEARCH_PRODUCT_CODE
                case 1:
                    return SEARCH_SELLING_PRICE
                case 2:
                    return SEARCH_SPECIAL_DELIVERY
                case 3:
                    return SEARCH_SEASON
                case 4:
                    return SEARCH_DATE_SEARCH
                case 5:
                    return ""
                case 6:
                    return SEARCH_SCANNER
                case 7:
                    return SEARCH_COPYWRITER_NAME
                default:
                    print("end")
            }
            case 2:
                switch index {
                case 0:
                    return SEARCH_STILL_STYLIST
                case 1:
                    return SEARCH_MODEL_STYLIST
                case 2:
                    return SEARCH_MANNAQUIN_STYLIST
                case 3:
                    return SEARCH_STILL_PHOTOGRAPHER
                case 4:
                    return SEARCH_MODEL_PHOTOGRAPHER
                case 5:
                    return SEARCH_MANNAQUIN_PHOTOGRAPHER
                default:
                    print("end")
            }
            default:
                print("end")
            }
        return ""
    }
    
    func getDateType(value: String) -> String {
        switch value {
        case "Select date type":
            return ""
        case CREATE_DATE:
            return SEARCH_CREATE_DATE
        case TEXT_ENRICHMENT_DATE:
            return SEARCH_ENRICHMENT_DATE
        case REQUEST_DATE:
            return SEARCH_REQUEST_DATE
        case PICK_DATE:
            return SEARCH_PICK_DATE
        case SCAN_IN_DATE:
            return SEARCH_SCAN_IN_DATE
        case SHOT_STILL_DATE:
            return SEARCH_SHOT_STILL_DATE
        case SHOT_MODEL_DATE:
            return SEARCH_SHOT_MODEL_DATE
        case SHOT_MANNAQUIN_DATE:
            return SEARCH_SHOT_MANNAQUIN_DATE
        case SCAN_OUT_DATE:
            return SEARCH_SCAN_OUT_DATE
        case COPYWRITE_DATE:
            return SEARCH_COPYWRITE_DATE
        case UPLOAD_DATE:
            return SEARCH_UPLOAD_DATE
        case VIDEO_SHOT_DATE:
            return SEARCH_VIDEO_SHOT_DATE
        case MODEL_UPLOAD_DATE:
            return SEARCH_MODEL_UPLOAD_DATE
        case MANNAQUIN_UPLOAD_DATE:
            return SEARCH_MANNAQUIN_UPLOAD_DATE
        case STILL_UPLOAD_DATE:
            return SEARCH_STILL_UPLOAD_DATE
        case DISPATCHED_DATE:
            return SEARCH_DISPATCHED_DATE
        case STYLE_SHOOT_DATE:
            return SEARCH_STYLE_SHOOT_DATE
        case PHOTO_DATE:
            return SEARCH_PHOTO_DATE
        case DELIVERY_DATE:
            return SEARCH_DELIVERY_DATE
        case COLLECTION_DATE:
            return SEARCH_COLLECTION_DATE
        default:
            print("end")
        }
        return ""
    }
}
//MARK: *************** Extension UIView ***************
extension UIView {
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func makeRoundCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
}

//MARK: *************** Extension UINavigationBar ***************
extension UINavigationBar {
    
    func addSeparator() {
        let separatorView = UIView.init(frame: CGRect(x: 0, y: self.frame.height-1, width: UIScreen.main.bounds.size.width, height: 1))
        separatorView.backgroundColor = UIColor.baYellow()
        separatorView.tag = 100
        self.addSubview(separatorView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: separatorView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: separatorView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: separatorView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 1)
        let heightConstraint = NSLayoutConstraint(item: separatorView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 1)
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        bottomConstraint.isActive = true
        heightConstraint.isActive = true
    }
    
    func hideSeparator() {
        if #available(iOS 11.0, *) {
            self.viewWithTag(100)?.removeFromSuperview()
        }
    }
}

//MARK: *************** Extension UIButton ***************
extension UIButton {
    
    func setTintAndTitleColor(tintColor: UIColor, titleColor: UIColor) {
        self.tintColor = tintColor
        self.setTitleColor(titleColor, for: .normal)
    }
}

//MARK: *************** Extension UILabel ***************
extension UILabel {
    
    func setFontMetrics(font: UIFont) {
        
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: font)
            self.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
}

//MARK: *************** Extension UITextField ***************
extension UITextField {
    
    func setFontMetrics(font: UIFont) {
        
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: font)
            self.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
    }
}
