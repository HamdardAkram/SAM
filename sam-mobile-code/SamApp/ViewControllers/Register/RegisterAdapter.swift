//
//  RegisterAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 18/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol RegisterAdapterDelegate: class {
    func getPickerView() -> ToolbarPickerView
    
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
}

class RegisterAdapter: NSObject {
    fileprivate let registerTableView: UITableView
    fileprivate weak var delegate: RegisterAdapterDelegate?
    
    var dataSource: [[String: String]] = [["title": "Client Name", "value": ""], ["title": "Email", "value": ""], ["title": "Client Location", "value": ""], ["title": "Full Name", "value": ""], ["title": "Mobile Number", "value": ""], ["title": "Location", "value": ""], ["title": "Role", "value": ""]] {
        didSet {
            //self.registerTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: RegisterAdapterDelegate) {
        self.registerTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.registerTableView.delegate = self
        self.registerTableView.dataSource = self
        
        self.registerCells()
    }
}

fileprivate extension RegisterAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let infoCell = UINib.init(nibName: "RegisterCell", bundle: Bundle.main)
        self.registerTableView.register(infoCell, forCellReuseIdentifier: "RegisterCell")
    }
}

extension RegisterAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RegisterCell.self), for: indexPath) as! RegisterCell
        let dict = self.dataSource[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self.delegate as? RegisterCellDelegate
        cell.setData(dict: dict)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension RegisterAdapter: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.detailTableView?.didTapOnRow(indexPath: indexPath)
    }
}

