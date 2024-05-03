//
//  User.swift
//  SamApp
//
//  Created by Muhammad Akram on 12/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

struct User: Codable {
    var message: String
    var statusCode: Int
    var status: Int
    var client_name: String
    var data: UserData?
    var productAttributes: [String]
    var clientLogo: String
    var scanInAttributes: String
    var scanOutAttributes: String
    var uniqueIdentifier: String
    var reports: [UserReport]
    var user_rights: [UserRights]
    var user_location: String
    var isModelManager: Bool = false
    var otp: Int?
    
    private enum CodingKeys: String, CodingKey {
        case message = "message"
        case statusCode = "statusCode"
        case status
        case client_name
        case data
        case productAttributes
        case clientLogo
        case scanInAttributes
        case scanOutAttributes
        case uniqueIdentifier
        case reports
        case user_rights
        case user_location
        case isModelManager
        case otp
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        status = try (container.decodeIfPresent(Int.self, forKey: .status) ?? 0)
        client_name = try (container.decodeIfPresent(String.self, forKey: .client_name) ?? "")
        data = try (container.decodeIfPresent(UserData.self, forKey: .data) ?? nil)
        productAttributes = try (container.decodeIfPresent([String].self, forKey: .productAttributes) ?? [])
        clientLogo = try (container.decodeIfPresent(String.self, forKey: .clientLogo) ?? "")
        scanInAttributes = try (container.decodeIfPresent(String.self, forKey: .scanInAttributes) ?? "")
        scanOutAttributes = try (container.decodeIfPresent(String.self, forKey: .scanOutAttributes) ?? "")
        uniqueIdentifier = try (container.decodeIfPresent(String.self, forKey: .uniqueIdentifier) ?? "")
        reports = try (container.decodeIfPresent([UserReport].self, forKey: .reports) ?? [])
        user_rights = try (container.decodeIfPresent([UserRights].self, forKey: .user_rights) ?? [])
        user_location = try (container.decodeIfPresent(String.self, forKey: .user_location) ?? "")
        isModelManager = try (container.decodeIfPresent(Bool.self, forKey: .isModelManager) ?? false)
        otp = try (container.decodeIfPresent(Int.self, forKey: .otp) ?? -1)
    }
}

struct UserData: Codable {
    var full_name: String
    var email: String
    var user_pass: String
    var roles: [String]
    var is_sam_user: Int
    var designation: String
    var user_type: String
    var client_id: [String]
    var location: String
    var employee_id: String
    var status: Int
    var user_group: String
    var prime_role: String
    var modifiedTime: Date
    var profile_image: String
}

struct UserReport: Codable {
    var _id: String
    var title: String
    var link: String
    var description: String
    var client: String
}
    
struct UserRights: Codable {
    var _id: String
    var group_id: String
    var action_items: [String: [String]]
    var menu_items: [String]
    var user_actions: [String]
}

struct TokenResponse: Decodable {
    let statusCode: Int
    let token: String
}
