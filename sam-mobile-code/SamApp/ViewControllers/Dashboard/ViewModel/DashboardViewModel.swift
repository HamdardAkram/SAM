//
//  DashboardViewModel.swift
//  SamApp
//
//  Created by Muhammad Akram on 27/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    
    fileprivate let networkClient: Networking
    @Published var dashboardData: DashboardData?
    
    init(networkClient: Networking) {
        self.networkClient = networkClient
    }
    
    func fetchDashboardData() {
        guard let user = getLoggedInUser() else {return}
        let params = ["client_name": user.client_name, "user_email": user.data?.email, "user_role": user.data?.user_group, "user_name": user.client_name]
        self.networkClient.sendDataWithArray(path: "api/reports/getDashboardData", method: .post, params: params as [String : Any], success: { (data, json) in
            
            do {
                let decoder = JSONDecoder()
                let dashboardDetail = try decoder.decode(DashboardModelResponse.self, from:
                    data!)
                print(dashboardDetail)
                self.dashboardData = dashboardDetail.data
                
            } catch let parsingError {
                print("Error", parsingError)
                //failure(parsingError)
            }
            
        }) { (error) in
            //failure(error)
            print("Error", error)
        }
    }
    
    //MARK: UI Business logic
    
    func numberOfSections() -> Int {
        return 5
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return 1
    }
    
    func heightForRow(index: IndexPath) -> CGFloat {
        switch index.section {
            case 0:
                return 265
            case 1:
                return 440
            case 2:
                return 415
            case 3:
                return 365
            case 4:
                return 390
            default: return 0
        }
    }
}
