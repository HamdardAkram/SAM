//
//  ProductInfoAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 05/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ProductInfoAdapterDelegate: class {
    
    //func didTapCheckout(inAdapter adapter: BasketAdapter)
}

class ProductInfoAdapter: NSObject {
    fileprivate let infoTableView: UITableView
    fileprivate weak var delegate: ProductInfoAdapterDelegate?
    
    var productInfo: ProductData? {
        didSet {
            if let headerView = self.infoTableView.tableHeaderView as? InfoHeaderView {
                headerView.productInfo = productInfo
            }
            self.infoTableView.reloadData()
        }
    }
    var dataSource:[[String: String]] = [] {
        didSet {
            self.infoTableView.reloadData()
        }
    }
    var isEditingOn: Bool = false {
        didSet {
            self.infoTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: ProductInfoAdapterDelegate) {
        self.infoTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        
        self.infoTableView.tableFooterView = UIView()
        self.registerCells()
        
        let user = getLoggedInUser()
        if user?.client_name.lowercased() == "bijenkorf" {
            self.infoTableView.tableHeaderView = getHeaderView()
        }
        else {
            self.infoTableView.tableHeaderView = UIView(frame: .zero)            
        }
        guard let attributes = user?.productAttributes else {
            return
        }
        for attribute in attributes {
            let str = attribute.replacingOccurrences(of: "_", with: " ")
            self.dataSource.append(["title": str.capitalized])
        }
        
    }
    
    func getHeaderView() -> UIView {
        let headerView = Bundle.main.loadNibNamed("InfoHeaderView", owner: self, options: nil)?.last
        guard let view = headerView as? InfoHeaderView else {
            return UIView()
        }
        view.contentView.backgroundColor = UIColor.black
        return view
    }
}

fileprivate extension ProductInfoAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let infoCell = UINib.init(nibName: "ProductInfoCell", bundle: Bundle.main)
        self.infoTableView.register(infoCell, forCellReuseIdentifier: "ProductInfoCell")
    }
}

extension ProductInfoAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductInfoCell.self), for: indexPath) as! ProductInfoCell
        cell.delegate = self.delegate as? ProductInfoCellDelegate
        let dict = self.dataSource[indexPath.row]
        if let data = self.productInfo {
            cell.setData(data: dict, productData: data, editMode: isEditingOn)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension ProductInfoAdapter: UITableViewDelegate {
    
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
