//
//  SetProductStatusAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 06/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SetProductStatusAdapterDelegate: class {
    
}

class SetProductStatusAdapter: NSObject {
    fileprivate let statusTableView: UITableView
    fileprivate weak var delegate: SetProductStatusAdapterDelegate?
    
    var dataSource:[ProductDetails] = [] {
        didSet {
            self.statusTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: SetProductStatusAdapterDelegate) {
        self.statusTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self
        self.statusTableView.tableHeaderView = getHeaderView()
        //self.statusTableView.tableFooterView = UIView()
        
        self.statusTableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(351))

        
        self.registerCells()
        self.registerHeaderAndFooter()
    }
    
    func getHeaderView() -> UIView {
        let headerView = Bundle.main.loadNibNamed("SetProductStatusHeaderView", owner: self, options: nil)?.last
        guard let view = headerView as? SetProductStatusHeaderView else {
            return UIView()
        }
        view.headerDelegate = self.delegate as? SetProductStatusHeaderViewDelegate
        view.contentView.backgroundColor = UIColor.black

        return view
    }
}

fileprivate extension SetProductStatusAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let infoCell = UINib.init(nibName: "SetProductStatusCell", bundle: Bundle.main)
        self.statusTableView.register(infoCell, forCellReuseIdentifier: "SetProductStatusCell")
    }
    
    func registerHeaderAndFooter() {
        let headerNib = UINib.init(nibName: "SectionHeaderView", bundle: Bundle.main)
        self.statusTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
    }
}

extension SetProductStatusAdapter: UITableViewDataSource {
 // MARK: UITableViewDataSource
 
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return dataSource.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SetProductStatusCell.self), for: indexPath) as! SetProductStatusCell
        let product = self.dataSource[indexPath.row]
        cell.setData(product: product)
        return cell
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView")
        let header = cell as! SectionHeaderView
        header.contentView.backgroundColor = UIColor.black
        
        header.setProductStatus()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SetProductStatusAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
