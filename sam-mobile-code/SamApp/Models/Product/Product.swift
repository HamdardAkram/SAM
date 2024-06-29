//
//  Product.swift
//  SamApp
//
//  Created by Leonid Peancovsky on 15/02/2018.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DynamicKey: CodingKey {
    
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    
    init?(intValue: Int) { return nil }
    
}

class ProductDetails: Decodable {
    var message: String
    var statusCode: VariacType
    var data: [ProductData]
    var totalscanned: Int
    var totalRecords: Int
    var toBeScanned: Bool
    var product_id: String
    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "statusCode"
        case data
        case totalscanned
        case totalRecords
        case toBeScanned
        case product_id
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        statusCode = try container.decode(VariacType.self, forKey: .statusCode)
        data = try (container.decodeIfPresent([ProductData].self, forKey: .data) ?? [])
        totalscanned = try (container.decodeIfPresent(Int.self, forKey: .totalscanned) ?? 0)
        totalRecords = try (container.decodeIfPresent(Int.self, forKey: .totalRecords) ?? 0)
        toBeScanned = try (container.decodeIfPresent(Bool.self, forKey: .toBeScanned) ?? false)
        product_id = try (container.decodeIfPresent(String.self, forKey: .product_id) ?? "")
    }
}

struct ProductData: Decodable {
    var _id: String
    var sku: String
    var barcode: String
    var productInfo: [String: VariacType] = ["": VariacType.string("")]
    var product_type: String
    var category: String
    var brand: String
    var description: String
    var colour: String
    var notes: [ProductNote]
    var status: VariacType
    var priority: String
    var session_id: String
    var scan_in_date: VariacType
    var sessions: [ProductSession]
    var scan_out_date: VariacType
    var wardrobe_product: Int
    var copywrite_date: VariacType
    var copywrite: ProductCopyright?
    var outfit: [ProductOutFit]
    var image_dir_year: String
    var image_dir_month: String
    var images: [ProductImages]
    var is_sample: Int
    var is_luxury: Int
    var requires_mannequin: Int
    var extra_details: Int
    var wrong_code: VariacType
    
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case sku = "sku"
        case barcode = "barcode"
        case productInfo
        case product_type
        case category
        case brand
        case description
        case colour
        case notes
        case status
        case priority
        case session_id
        case scan_in_date
        case sessions
        case scan_out_date
        case wardrobe_product
        case copywrite_date
        case copywrite
        case outfit
        case image_dir_year
        case image_dir_month
        case images
        case is_sample
        case is_luxury
        case requires_mannequin
        case extra_details
        case wrong_code
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let subContainer = try decoder.container(keyedBy: DynamicKey.self)
        
        let user = getLoggedInUser()
        if let attributes = user?.productAttributes {
            for key in subContainer.allKeys {
                print(subContainer.allKeys.count)
                if attributes.contains(key.stringValue) {
                    do {
                        let value = (try subContainer.decodeIfPresent(VariacType.self, forKey: key)) ?? VariacType.string("")
                        productInfo[key.stringValue] = value
                    } catch {
                        productInfo[key.stringValue] = VariacType.string("")
                    }
                }
            }
        }
        _id = (try container.decodeIfPresent(String.self, forKey: ._id)) ?? ""
        sku = (try container.decodeIfPresent(String.self, forKey: .sku)) ?? ""
        barcode = (try container.decodeIfPresent(String.self, forKey: .barcode)) ?? ""
        
        product_type = (try container.decodeIfPresent(String.self, forKey: .product_type)) ?? ""
        category = (try container.decodeIfPresent(String.self, forKey: .category)) ?? ""
        brand = (try container.decodeIfPresent(String.self, forKey: .brand)) ?? ""
        description = (try container.decodeIfPresent(String.self, forKey: .description)) ?? ""
        colour = (try container.decodeIfPresent(String.self, forKey: .colour)) ?? ""
        status = (try container.decodeIfPresent(VariacType.self, forKey: .status)) ?? VariacType.string("")
        priority = (try container.decodeIfPresent(String.self, forKey: .priority)) ?? ""
        session_id = (try container.decodeIfPresent(String.self, forKey: .session_id)) ?? ""
        
        scan_in_date = (try container.decodeIfPresent(VariacType.self, forKey: .scan_in_date)) ?? VariacType.string("")
        sessions = try (container.decodeIfPresent([ProductSession].self, forKey: .sessions) ?? [])
        do {
            notes = try (container.decodeIfPresent([ProductNote].self, forKey: .notes) ?? [])
        } catch {
            notes = []
        }
        scan_out_date = (try container.decodeIfPresent(VariacType.self, forKey: .scan_out_date)) ?? VariacType.string("")
        wardrobe_product = (try container.decodeIfPresent(Int.self, forKey: .wardrobe_product)) ?? 0
        copywrite_date = (try container.decodeIfPresent(VariacType.self, forKey: .copywrite_date)) ?? VariacType.string("")
        copywrite = (try container.decodeIfPresent(ProductCopyright.self, forKey: .copywrite)) ?? nil
        outfit = try (container.decodeIfPresent([ProductOutFit].self, forKey: .outfit) ?? [])
        image_dir_year = try (container.decodeIfPresent(String.self, forKey: .image_dir_year) ?? "")
        image_dir_month = try (container.decodeIfPresent(String.self, forKey: .image_dir_month) ?? "")
        images = try (container.decodeIfPresent([ProductImages].self, forKey: .images) ?? [])
        
        is_sample = try (container.decodeIfPresent(Int.self, forKey: .is_sample) ?? 0)
        is_luxury = try (container.decodeIfPresent(Int.self, forKey: .is_luxury) ?? 0)
        requires_mannequin = try (container.decodeIfPresent(Int.self, forKey: .requires_mannequin) ?? 0)
        extra_details = try (container.decodeIfPresent(Int.self, forKey: .extra_details) ?? 0)
        wrong_code = try (container.decodeIfPresent(VariacType.self, forKey: .wrong_code) ?? VariacType.string(""))
    }
}

struct ProductSession: Codable {
    var scan_in_date: VariacType
    var scan_in_by: String
    var scan_out_date: VariacType
    var scan_out_by: String
    
    var sla: VariacType
    var billable: VariacType
    var product_session_id: Int
    
    var copywrite_date: VariacType
    var copywriter_name: String
    
    var photo_still_date: VariacType
    var photo_model_date: VariacType
    var photo_mannequin_date: VariacType
    
    var still_photographer: String
    var model_photographer: String
    var mannequin_photographer: String
    
    var still_stylist_name: String
    var model_stylist_name: String
    var mannequin_stylist_name: String
    var video_stylist_name: String
    var model_name: String

    var upload_date: VariacType
    var still_upload_date: VariacType
    var model_upload_date: VariacType
    var mannequin_upload_date: VariacType
    
    var uploaded_by: String
    var still_uploaded_by: String
    var model_uploaded_by: String
    var mannequin_uploaded_by: String
    
    var video_shot_date: VariacType
    var videography_by: String

    var modified_date: VariacType
    var modified_by: String

    var photo_date: VariacType
    var location: String
    var user_rights: String
    var plugin: String
    
    var wrong_code: VariacType
    var wrongproduct_coment: String
    var is_model_manager: String
    
    private enum CodingKeys: String, CodingKey {
        case scan_in_date = "scan_in_date"
        case scan_in_by = "scan_in_by"
        case scan_out_date
        case scan_out_by
        case sla = "sla"
        case billable = "billable"
        case product_session_id = "product_session_id"
        case copywrite_date = "copywrite_date"
        case copywriter_name
        case photo_still_date = "photo_still_date"
        case photo_model_date = "photo_model_date"
        case photo_mannequin_date = "photo_mannequin_date"
        case upload_date
        case still_upload_date = "still_upload_date"
        case model_upload_date = "model_upload_date"
        case mannequin_upload_date = "mannequin_upload_date"
        case video_shot_date
        case modified_date
        case still_photographer
        case model_photographer
        case mannequin_photographer
        case still_stylist_name
        case model_stylist_name
        case mannequin_stylist_name
        case video_stylist_name
        case videography_by
        case modified_by
        case uploaded_by
        case still_uploaded_by
        case model_uploaded_by
        case mannequin_uploaded_by
        case model_name
        case photo_date
        case location
        case user_rights
        case plugin
        case wrong_code
        case wrongproduct_coment
        case is_model_manager
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scan_in_by, forKey: .scan_in_by)
        try container.encode(scan_out_by, forKey: .scan_out_by)
        try container.encode(product_session_id, forKey: .product_session_id)
        try container.encode(copywriter_name, forKey: .copywriter_name)
        try container.encode(still_stylist_name, forKey: .still_stylist_name)
        try container.encode(model_stylist_name, forKey: .model_stylist_name)
        try container.encode(mannequin_stylist_name, forKey: .mannequin_stylist_name)
        try container.encode(video_stylist_name, forKey: .video_stylist_name)
        try container.encode(videography_by, forKey: .videography_by)
        try container.encode(modified_by, forKey: .modified_by)
        try container.encode(still_photographer, forKey: .still_photographer)
        try container.encode(model_photographer, forKey: .model_photographer)
        try container.encode(mannequin_photographer, forKey: .mannequin_photographer)
        try container.encode(location, forKey: .location)
        try container.encode(user_rights, forKey: .user_rights)
        try container.encode(plugin, forKey: .plugin)
        try container.encode(wrong_code, forKey: .wrong_code)
        try container.encode(wrongproduct_coment, forKey: .wrongproduct_coment)
        try container.encode(is_model_manager, forKey: .is_model_manager)
        try container.encode(scan_in_date, forKey: .scan_in_date)
        try container.encode(scan_out_date, forKey: .scan_out_date)
        try container.encode(photo_date, forKey: .photo_date)
        try container.encode(photo_still_date, forKey: .photo_still_date)
        try container.encode(photo_model_date, forKey: .photo_model_date)
        try container.encode(photo_mannequin_date, forKey: .photo_mannequin_date)
        try container.encode(video_shot_date, forKey: .video_shot_date)
        try container.encode(upload_date, forKey: .upload_date)
        try container.encode(still_upload_date, forKey: .still_upload_date)
        try container.encode(model_upload_date, forKey: .model_upload_date)
        try container.encode(mannequin_upload_date, forKey: .mannequin_upload_date)
        try container.encode(uploaded_by, forKey: .uploaded_by)
        try container.encode(still_uploaded_by, forKey: .still_uploaded_by)
        try container.encode(model_uploaded_by, forKey: .model_uploaded_by)
        try container.encode(mannequin_uploaded_by, forKey: .mannequin_uploaded_by)
        try container.encode(model_name, forKey: .model_name)
        try container.encode(sla, forKey: .sla)
        try container.encode(billable, forKey: .billable)
        try container.encode(copywrite_date, forKey: .copywrite_date)
        try container.encode(modified_date, forKey: .modified_date)
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        scan_in_date = (try container.decodeIfPresent(VariacType.self, forKey: .scan_in_date)) ?? VariacType.string("")
        scan_out_date = (try container.decodeIfPresent(VariacType.self, forKey: .scan_out_date)) ?? VariacType.string("")
        scan_in_by = try (container.decodeIfPresent(String.self, forKey: .scan_in_by) ?? "")
        scan_out_by = try (container.decodeIfPresent(String.self, forKey: .scan_out_by) ?? "")
        sla = try (container.decodeIfPresent(VariacType.self, forKey: .sla) ?? VariacType.string(""))
        billable = try (container.decodeIfPresent(VariacType.self, forKey: .billable) ?? VariacType.string(""))
        product_session_id = try (container.decodeIfPresent(Int.self, forKey: .product_session_id) ?? 0)
        
        copywrite_date = (try container.decodeIfPresent(VariacType.self, forKey: .copywrite_date)) ?? VariacType.string("")
        copywriter_name = try (container.decodeIfPresent(String.self, forKey: .copywriter_name) ?? "")
        
        photo_still_date = (try container.decodeIfPresent(VariacType.self, forKey: .photo_still_date)) ?? VariacType.string("")
        photo_mannequin_date = (try container.decodeIfPresent(VariacType.self, forKey: .photo_mannequin_date)) ?? VariacType.string("")
        photo_model_date = (try container.decodeIfPresent(VariacType.self, forKey: .photo_model_date)) ?? VariacType.string("")
        still_upload_date = (try container.decodeIfPresent(VariacType.self, forKey: .still_upload_date)) ?? VariacType.string("")
        model_upload_date = (try container.decodeIfPresent(VariacType.self, forKey: .model_upload_date)) ?? VariacType.string("")
        mannequin_upload_date = (try container.decodeIfPresent(VariacType.self, forKey: .mannequin_upload_date)) ?? VariacType.string("")
        upload_date = (try container.decodeIfPresent(VariacType.self, forKey: .upload_date)) ?? VariacType.string("")
        video_shot_date = (try container.decodeIfPresent(VariacType.self, forKey: .video_shot_date)) ?? VariacType.string("")
        modified_date = (try container.decodeIfPresent(VariacType.self, forKey: .modified_date)) ?? VariacType.string("")
        photo_date = (try container.decodeIfPresent(VariacType.self, forKey: .photo_date)) ?? VariacType.string("")
        
        mannequin_photographer = (try container.decodeIfPresent(String.self, forKey: .mannequin_photographer)) ?? ""
        mannequin_stylist_name = (try container.decodeIfPresent(String.self, forKey: .mannequin_stylist_name)) ?? ""
        video_stylist_name = (try container.decodeIfPresent(String.self, forKey: .video_stylist_name)) ?? ""
        videography_by = (try container.decodeIfPresent(String.self, forKey: .videography_by)) ?? ""
        modified_by = (try container.decodeIfPresent(String.self, forKey: .modified_by)) ?? ""
        model_photographer = (try container.decodeIfPresent(String.self, forKey: .model_photographer)) ?? ""
        
        uploaded_by = (try container.decodeIfPresent(String.self, forKey: .uploaded_by)) ?? ""
        still_uploaded_by = (try container.decodeIfPresent(String.self, forKey: .still_uploaded_by)) ?? ""
        model_uploaded_by = (try container.decodeIfPresent(String.self, forKey: .model_uploaded_by)) ?? ""
        mannequin_uploaded_by = (try container.decodeIfPresent(String.self, forKey: .mannequin_uploaded_by)) ?? ""
        model_name = (try container.decodeIfPresent(String.self, forKey: .model_name)) ?? ""
        
        location = (try container.decodeIfPresent(String.self, forKey: .location)) ?? ""
        user_rights = (try container.decodeIfPresent(String.self, forKey: .user_rights)) ?? ""
        plugin = (try container.decodeIfPresent(String.self, forKey: .plugin)) ?? ""
        still_stylist_name = (try container.decodeIfPresent(String.self, forKey: .still_stylist_name)) ?? ""
        model_stylist_name = (try container.decodeIfPresent(String.self, forKey: .model_stylist_name)) ?? ""
        still_photographer = (try container.decodeIfPresent(String.self, forKey: .still_photographer)) ?? ""
        wrong_code = (try container.decodeIfPresent(VariacType.self, forKey: .wrong_code)) ?? VariacType.string("")
        wrongproduct_coment = (try container.decodeIfPresent(String.self, forKey: .wrongproduct_coment)) ?? ""
        is_model_manager = (try container.decodeIfPresent(String.self, forKey: .is_model_manager)) ?? ""
    }
}

struct ProductCopyright: Decodable {
    
    var product_description: String
    var inspiration: String
    var editors_note: String
    var bullet_1: String
    var bullet_2: String
    var bullet_3: String
    var bullet_4: String
    var bullet_5: String
    var bullet_6: String
    var bullet_7: String
    var bullet_8: String
    var bullet_9: String
    var bullet_10: String
    var bullet_11: String
    var qc_approved: VariacType
    var copywrite_status: VariacType
    var product_copywrite_by: String
    var copywrite_approval_date: VariacType
    
    private enum CodingKeys: String, CodingKey {
        case product_description
        case inspiration
        case editors_note
        case bullet_1
        case bullet_2
        case bullet_3
        case bullet_4
        case bullet_5
        case bullet_6
        case bullet_7
        case bullet_8
        case bullet_9
        case bullet_10
        case bullet_11
        case qc_approved
        case copywrite_status
        case product_copywrite_by
        case copywrite_approval_date
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        product_description = try (container.decodeIfPresent(String.self, forKey: .product_description) ?? "")
        inspiration = try (container.decodeIfPresent(String.self, forKey: .inspiration) ?? "")
        editors_note = try (container.decodeIfPresent(String.self, forKey: .editors_note) ?? "")
        bullet_1 = try (container.decodeIfPresent(String.self, forKey: .bullet_1) ?? "")
        bullet_2 = try (container.decodeIfPresent(String.self, forKey: .bullet_2) ?? "")
        bullet_3 = try (container.decodeIfPresent(String.self, forKey: .bullet_3) ?? "")
        bullet_4 = try (container.decodeIfPresent(String.self, forKey: .bullet_4) ?? "")
        bullet_5 = try (container.decodeIfPresent(String.self, forKey: .bullet_5) ?? "")
        bullet_6 = try (container.decodeIfPresent(String.self, forKey: .bullet_6) ?? "")
        bullet_7 = try (container.decodeIfPresent(String.self, forKey: .bullet_7) ?? "")
        bullet_8 = try (container.decodeIfPresent(String.self, forKey: .bullet_8) ?? "")
        bullet_9 = try (container.decodeIfPresent(String.self, forKey: .bullet_9) ?? "")
        bullet_10 = try (container.decodeIfPresent(String.self, forKey: .bullet_10) ?? "")
        bullet_11 = try (container.decodeIfPresent(String.self, forKey: .bullet_11) ?? "")
        qc_approved = try (container.decodeIfPresent(VariacType.self, forKey: .qc_approved) ?? VariacType.string(""))
        copywrite_status = try (container.decodeIfPresent(VariacType.self, forKey: .copywrite_status) ?? VariacType.string(""))
        product_copywrite_by = try (container.decodeIfPresent(String.self, forKey: .product_copywrite_by) ?? "")
        copywrite_approval_date = try (container.decodeIfPresent(VariacType.self, forKey: .copywrite_approval_date) ?? VariacType.string(""))
    }
}

struct ProductOutFit: Decodable {

    var _id: String
    var sku_long: String
    var description: String
    
    private enum CodingKeys: String, CodingKey {
        case _id
        case sku_long
        case description
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try (container.decodeIfPresent(String.self, forKey: ._id) ?? "")
        sku_long = try (container.decodeIfPresent(String.self, forKey: .sku_long) ?? "")
        description = try (container.decodeIfPresent(String.self, forKey: .description) ?? "")
    }
}

struct ImageData: Decodable {
    var message: String
    var images: [ProductImages]
    
    private enum CodingKeys: String, CodingKey {
        case message
        case images
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        message = try (container.decodeIfPresent(String.self, forKey: .message) ?? "")
        images = try (container.decodeIfPresent([ProductImages].self, forKey: .images) ?? [])
    }
}

struct ProductImages: Decodable {

    var _id: String
    var image_name: String
    
    private enum CodingKeys: String, CodingKey {
        case _id
        case image_name
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try (container.decodeIfPresent(String.self, forKey: ._id) ?? "")
        image_name = try (container.decodeIfPresent(String.self, forKey: .image_name) ?? "")
    }
}

struct ProductNote: Codable {
    var comment: String
    var comment_by: String
    var comment_date: VariacType
    
    private enum CodingKeys: String, CodingKey {
        case comment
        case comment_by
        case comment_date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(comment, forKey: .comment)
        try container.encode(comment_by, forKey: .comment_by)
        try container.encode(comment_date, forKey: .comment_date)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        comment = try (container.decodeIfPresent(String.self, forKey: .comment) ?? "")
        comment_by = try (container.decodeIfPresent(String.self, forKey: .comment_by) ?? "")
        comment_date = try (container.decodeIfPresent(VariacType.self, forKey: .comment_date) ?? VariacType.string(""))
    }
}

enum VariacType: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .double(let doubleValue): try container.encode(doubleValue)
            case .string(let stringValue): try container.encode(stringValue)
            case .int(let intValue): try container.encode(intValue)
            case .bool(let boolValue): try container.encode(boolValue)
        }
    }
    
    case double(Double)
    case string(String)
    case int(Int)
    case bool(Bool)
    
    private enum CodingKeys: String, CodingKey {
        case Value
    }
    
    
    
    init(from decoder: Decoder) throws {
        
        if let doubleValue = try? decoder.singleValueContainer().decode(Double.self)  {
            self = .double(doubleValue)
            return
        }
        if let stringValue = try? decoder.singleValueContainer().decode(String.self){
            self = .string(stringValue)
            return
        }
        if let intValue = try? decoder.singleValueContainer().decode(Int.self){
            self = .int(intValue)
            return
        }
        if let boolValue = try? decoder.singleValueContainer().decode(Bool.self){
            self = .bool(boolValue)
        }
        throw VariacError.missingValue
    }
    
    enum VariacError: Error {
        case missingValue
    }
}

extension VariacType {
    var Value:String {
        switch self {
        case .double(let doublevalue):
            return String(doublevalue)
        case .string(let stringValue):
            return stringValue
        case .int(let intValue):
            return String(intValue)
        case .bool(let boolValue):
            return String(boolValue)
        default: print("Variac type key failed = ", self)
        }
    }
}

extension KeyedEncodingContainer where Key == DynamicKey {
    
    mutating func encodeDynamicKeyValues(withDictionary dictionary: [String : Any]) throws {
        for (key, value) in dictionary {
            let dynamicKey = DynamicKey(stringValue: key)!
            // Following won't work:
            // let v = value as Encodable
            // try propertiesContainer.encode(v, forKey: dynamicKey)
            // Therefore require explicitly casting to the supported value type:
            switch value {
            case let v as String: try encode(v, forKey: dynamicKey)
            case let v as Int: try encode(v, forKey: dynamicKey)
            case let v as Double: try encode(v, forKey: dynamicKey)
            case let v as Float: try encode(v, forKey: dynamicKey)
            case let v as Bool: try encode(v, forKey: dynamicKey)
            default: print("Type \(type(of: value)) not supported")
            }
        }
    }
    
}

extension KeyedDecodingContainer where Key == DynamicKey {
    
    func decodeDynamicKeyValues() -> [String : Any] {
        var dict = [String : Any]()
        for key in allKeys {
            // Once again, following decode doesn't work, therefore requires explicitly decoding each supported type.
            // propertiesContainer.decode(?, forKey: key)
            if let v = try? decode(String.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Bool.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Int.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Double.self, forKey: key) {
                dict[key.stringValue] = v
            } else if let v = try? decode(Float.self, forKey: key) {
                dict[key.stringValue] = v
            } else {
                print("Key \(key.stringValue) type not supported")
            }
        }
        return dict
    }
}
