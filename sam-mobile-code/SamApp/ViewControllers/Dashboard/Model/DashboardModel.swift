//
//  DashboardModel.swift
//  SamApp
//
//  Created by Muhammad Akram on 27/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import Foundation

struct DashboardModelResponse: Codable {
    let statusCode: Int
    let message: String
    let data: DashboardData
}

struct DashboardData: Codable {
    let studio_performance: StudioPerformanceData?
    let employee_performance: [String: EmployeeData]?
    let studio_state: StudioStateData?
    let product_SLA: [String: ProductSLAData]?
}

struct EmployeeData: Codable {
    let daily: EmployeeDailyData
    let monthly: EmployeeMonthlyData
}

struct EmployeeDailyData: Codable {
    let daily_dates: [String]?
    let model_photographer_count: [Int]?
    let mannequin_photographer_count: [Int]?
    let still_photographer_count: [Int]?
    let photo_ecom_photographer_count: [Int]?
    let image360_photographer_count: [Int]?
    let copywriter_name_count: [Int]?
    let video_photographer_count: [Int]?
}

struct EmployeeMonthlyData: Codable {
    let monthly_dates: [String]?
    let model_photographer_count: [Int]?
    let mannequin_photographer_count: [Int]?
    let still_photographer_count: [Int]?
    let photo_ecom_photographer_count: [Int]?
    let image360_photographer_count: [Int]?
    let copywriter_name_count: [Int]?
    let video_photographer_count: [Int]?
}

struct ProductSLAData: Codable {
    let product_SLA: [Int]?
    let product_SLA_label: [String]?
    let product_shoot_data: [Int]?
    let product_shoot_data_label: [String]?
    let product_production_data: [Int]?
    let product_production_data_label: [String]?
}

//MARK: Studio Performance Data
struct StudioPerformanceData: Codable {
    let daily: StudioPerformanceDailyData?
    let monthly: StudioPerformanceMonthlyData?
}

struct StudioPerformanceDailyData: Codable {
    let daily_dates: [String]?
    let daily_scan_in_count: [Int]?
    let daily_photo_model_count: [Int]?
    let daily_photo_mannequin_count: [Int]?
    let daily_photo_still_count: [Int]?
    let daily_photo_ecom_count: [Int]?
    let daily_photo_image360_count: [Int]?
    let daily_copywrite_count: [Int]?
    let daily_video_shot_count: [Int]?
}

struct StudioPerformanceMonthlyData: Codable {
    let monthly_dates: [String]?
    let monthly_scan_in_count: [Int]?
    let monthly_photo_model_count: [Int]?
    let monthly_photo_mannequin_count: [Int]?
    let monthly_photo_still_count: [Int]?
    let monthly_photo_ecom_count: [Int]?
    let monthly_photo_image360_count: [Int]?
    let monthly_copywrite_count: [Int]?
    let monthly_video_shot_count: [Int]?
}

//MARK: Studio State Data
struct StudioStateData: Codable {
    let daily: StudioStateDailyData?
    let monthly: StudioStateMonthlyData?
}

struct StudioStateDailyData: Codable {
    let daily_dates: [String]?
    let total_product_scan_in: [Int]?
    let total_product_shoot: [Int]?
    let total_image_delivered: [Int]?
    let total_product_delivered: [Int]?
    let total_product_scan_out: [Int]?
}

struct StudioStateMonthlyData: Codable {
    let daily_dates: [String]?
    let total_product_scan_in: [Int]?
    let total_product_shoot: [Int]?
    let total_image_delivered: [Int]?
    let total_product_delivered: [Int]?
    let total_product_scan_out: [Int]?
}


