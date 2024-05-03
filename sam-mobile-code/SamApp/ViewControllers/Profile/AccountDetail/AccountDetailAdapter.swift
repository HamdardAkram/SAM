//
//  AccountDetailAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/01/20.
//  Copyright © 2020 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AccountDetailAdapterDelegate: class {
    
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
}

class AccountDetailAdapter: NSObject {

    fileprivate let accountDetailTableView: UITableView
    fileprivate weak var accountDetailView: AccountDetailView?
    
    fileprivate weak var delegate: AccountDetailAdapterDelegate?
    
    var dataSource:[[String: String]] = [["title": "User Name", "value": ""], ["title": "Full Name", "value": ""], ["title": "Current Password", "value": ""], ["title": "New Password", "value": ""], ["title": "Confirm Password", "value": ""]] {
        didSet {
            self.accountDetailTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: AccountDetailAdapterDelegate) {
        self.accountDetailTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.accountDetailTableView.delegate = self
        self.accountDetailTableView.dataSource = self
        self.accountDetailTableView.tableFooterView = UIView()
        self.registerCells()
    }
}

fileprivate extension AccountDetailAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "AccountDetailCell", bundle: Bundle.main)
        self.accountDetailTableView.register(summaryCell, forCellReuseIdentifier: "AccountDetailCell")
    }
}

extension AccountDetailAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountDetailCell.self), for: indexPath) as! AccountDetailCell
        
        let data = dataSource[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self.delegate as? AccountDetailCellDelegate
        cell.set(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension AccountDetailAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

