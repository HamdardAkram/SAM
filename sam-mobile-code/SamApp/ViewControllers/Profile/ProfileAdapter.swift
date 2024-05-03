//
//  ProfileAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ProfileAdapter: NSObject {

    fileprivate let profileTableView: UITableView
    fileprivate weak var profileView: ProfileView?
    
    var dataSource:[String] = [] {
        didSet {
            self.profileTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, profileView: ProfileView) {
        self.profileTableView = tableView
        self.profileView = profileView
        
        super.init()
        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.tableFooterView = UIView()
        self.registerCells()
        
        let user = getLoggedInUser()
        let userRights = user?.user_rights[0]
        guard let actions = userRights?.user_actions else {
            return
        }
        if actions.contains("account_details") {
            self.dataSource.append("Account Details")
        }
        if actions.contains("prefrences") {
            self.dataSource.append("Preferences")
        }
        if actions.contains("model_manager") {
            self.dataSource.append("Model Manager")
        }
        if actions.contains("logout") {
            self.dataSource.append("Logout")
        }
    }
}

fileprivate extension ProfileAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main)
        self.profileTableView.register(summaryCell, forCellReuseIdentifier: "ProfileTableViewCell")
    }
}

extension ProfileAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath) as! ProfileTableViewCell
        
        let data = dataSource[indexPath.row]
        cell.set(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ProfileAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.profileView?.didTapOnRow(indexPath: indexPath)
    }
}

