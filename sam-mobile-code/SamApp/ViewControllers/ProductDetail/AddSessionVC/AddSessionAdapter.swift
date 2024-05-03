//
//  AddSessionAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 06/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AddSessionAdapterDelegate: class {
    func addSessionClicked() 
    func cancelClicked()
}

class AddSessionAdapter: NSObject {
    
    fileprivate let sessionTableView: UITableView
    fileprivate weak var delegate: AddSessionAdapterDelegate?
    
    var billable: String = "0"
    var sla: String = "0"
    
    var dataSource:[[String: String]] = [["key": "Billable?", "value": ""], ["key": "Affects SLA?", "value": ""]] {
        didSet {
            self.sessionTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: AddSessionAdapterDelegate) {
        self.sessionTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.sessionTableView.delegate = self
        self.sessionTableView.dataSource = self
        self.sessionTableView.tableHeaderView = getHeaderView()
        self.sessionTableView.tableFooterView = getFooterView()
        self.registerCells()
    }
    
    func getHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.sessionTableView.frame.size.width, height: 40))
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: self.sessionTableView.frame.size.width - 20, height: 20))
        label.text = "Add a new photo shot session:"
        label.textAlignment = .left
        label.font = UIFont.tofinoMediumFifteen()
        label.textColor = UIColor.white
        
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.samBlack()
        return headerView
    }
    
    func getFooterView() -> UIView {
        let footerView = Bundle.main.loadNibNamed("AddSessionFooterView", owner: self, options: nil)?.last
        guard let view = footerView as? AddSessionFooterView else {
            return UIView()
        }
        view.sessionFooterDelegate = self
        //view.backgroundColor = UIColor.samBlack()
        return view
    }
}

fileprivate extension AddSessionAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let sessionCell = UINib.init(nibName: "AddSessionCell", bundle: Bundle.main)
        self.sessionTableView.register(sessionCell, forCellReuseIdentifier: "AddSessionCell")
    }
}

extension AddSessionAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddSessionCell.self), for: indexPath) as! AddSessionCell
        let dict = self.dataSource[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.setData(data: dict)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddSessionAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.detailTableView?.didTapOnRow(indexPath: indexPath)
    }
}

extension AddSessionAdapter: AddSessionFooterViewDelegate {
    func addSessionClicked() {
        self.delegate?.addSessionClicked()
    }
    
    func cancelClicked() {
        self.delegate?.cancelClicked()
    }
}

extension AddSessionAdapter: AddSessionCellDelegate {
    func checkButtonClicked(button: UIButton) {
        if button.tag == 0 {
            self.billable = (button.isSelected == true) ? "1" : "0"
        }
        else {
            self.sla = (button.isSelected == true) ? "1" : "0"
        }
    }
}
