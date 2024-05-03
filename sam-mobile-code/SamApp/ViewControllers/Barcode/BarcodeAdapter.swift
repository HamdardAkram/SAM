//
//  BarcodeAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class BarcodeAdapter: NSObject {

    fileprivate let barcodeTableView: UITableView
    fileprivate weak var barcodeView: BarcodeView?
    
    var dataSource:[String] = ["Scan Products In", "Scan Products Out", "Scan Product to set status", "Non Production Scan In", "Wardrobe Scan In", "Wardrobe Scan Out"] {
        didSet {
            self.barcodeTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, barcodeView: BarcodeView) {
        self.barcodeTableView = tableView
        self.barcodeView = barcodeView
        
        super.init()
        
        self.barcodeTableView.delegate = self
        self.barcodeTableView.dataSource = self
        self.barcodeTableView.tableFooterView = UIView()
        self.registerCells()
    }
}

fileprivate extension BarcodeAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let labelCell = UINib.init(nibName: "BarcodeTableViewCell", bundle: Bundle.main)
        self.barcodeTableView.register(labelCell, forCellReuseIdentifier: "BarcodeTableViewCell")
    }
}

extension BarcodeAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BarcodeTableViewCell.self), for: indexPath) as! BarcodeTableViewCell
        
        let data = dataSource[indexPath.row]
        cell.set(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}

extension BarcodeAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.barcodeView?.didTapOnRow(indexPath: indexPath)
    }
}

