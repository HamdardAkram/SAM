//
//  PreferenceModel.swift
//  SamApp
//
//  Created by Muhammad Akram on 10/02/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import Foundation

struct ModelManagerPreference: Decodable {
    let message: String
    let statusCode: Int
    let data: [ModelManagerPreferenceData]
    let totalRecords: Int
}

struct ModelManagerPreferenceData: Codable {
    
    var _id: String
    let model_id: String
    let model_name: String
    let model_last_name: String
    let model_agency: String
    let model_price: String
    let model_currency: String
    let model_height: String
    let model_bust: String
    let model_waist: String
    let model_hips: String
    let model_shoe: String
    let model_hair: String
    let model_eyes: String
    let model_gender: String
    let model_headless: String
    let retention_days: String
    let model_comments: String
    let model_active: Int
    let createdTime: VariacType
    let modifiedTime: VariacType
    var clients: [String]
    
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case model_id = "model_id"
        case model_name
        case model_last_name
        case model_agency
        case model_price
        case model_currency
        case model_height
        case model_bust
        case model_waist
        case model_hips
        case model_shoe
        case model_hair
        case model_eyes
        case model_gender
        case model_headless
        case retention_days
        case model_comments
        case model_active
        case createdTime
        case modifiedTime
        case clients
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        model_id = try container.decode(String.self, forKey: .model_id)
        model_name = try (container.decodeIfPresent(String.self, forKey: .model_name) ?? "")
        model_last_name = try (container.decodeIfPresent(String.self, forKey: .model_last_name) ?? "")
        model_agency = try (container.decodeIfPresent(String.self, forKey: .model_agency) ?? "")
        model_price = try (container.decodeIfPresent(String.self, forKey: .model_price) ?? "")
        model_currency = try (container.decodeIfPresent(String.self, forKey: .model_currency) ?? "")
        model_height = try (container.decodeIfPresent(String.self, forKey: .model_height) ?? "")
        model_bust = try (container.decodeIfPresent(String.self, forKey: .model_bust) ?? "")
        model_waist = try (container.decodeIfPresent(String.self, forKey: .model_waist) ?? "")
        model_hips = try (container.decodeIfPresent(String.self, forKey: .model_hips) ?? "")
        model_shoe = try (container.decodeIfPresent(String.self, forKey: .model_shoe) ?? "")
        model_hair = try (container.decodeIfPresent(String.self, forKey: .model_hair) ?? "")
        model_eyes = try (container.decodeIfPresent(String.self, forKey: .model_eyes) ?? "")
        
        model_gender = try (container.decodeIfPresent(String.self, forKey: .model_gender) ?? "")
        model_headless = try (container.decodeIfPresent(String.self, forKey: .model_headless) ?? "")
        retention_days = try (container.decodeIfPresent(String.self, forKey: .retention_days) ?? "")
        model_comments = try (container.decodeIfPresent(String.self, forKey: .model_comments) ?? "")
        model_active = try (container.decodeIfPresent(Int.self, forKey: .model_active) ?? 0)
        createdTime = try (container.decodeIfPresent(VariacType.self, forKey: .createdTime) ?? VariacType.string(""))
        modifiedTime = try (container.decodeIfPresent(VariacType.self, forKey: .modifiedTime) ?? VariacType.string(""))
        do {
            clients = try (container.decodeIfPresent([String].self, forKey: .clients) ?? [])
        } catch {
            clients = []
        }
    }
}
