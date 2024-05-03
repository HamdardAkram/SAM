//
//  CopywriteAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 26/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol CopywriteAdapterDelegate: class {
    
}

class CopywriteAdapter: NSObject {
    fileprivate let copywriteTableView: UITableView
    fileprivate weak var delegate: CopywriteAdapterDelegate?
    
    
    var dataSource:[[String: String]] = [] {
        didSet {
            self.copywriteTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: CopywriteAdapterDelegate) {
        self.copywriteTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.copywriteTableView.delegate = self
        self.copywriteTableView.dataSource = self

        self.registerCells()
    }
}

fileprivate extension CopywriteAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let copywriteCell = UINib.init(nibName: "CopywriteCell", bundle: Bundle.main)
        self.copywriteTableView.register(copywriteCell, forCellReuseIdentifier: "CopywriteCell")
    }
}

extension CopywriteAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CopywriteCell.self), for: indexPath) as! CopywriteCell
        let dict = self.dataSource[indexPath.row]
        cell.setData(dict: dict)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension CopywriteAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
