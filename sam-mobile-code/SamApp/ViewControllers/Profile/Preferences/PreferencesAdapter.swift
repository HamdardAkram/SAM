//
//  PreferencesAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import MBRadioButton

protocol PreferencesAdapterDelegate: class {
    func didTapOnRow(indexPath: IndexPath)
    //func radioButtonSelected(button: RadioButton)
    func textFieldEndEditing(textField: UITextField)
    func textFieldBeginEditing(textField: UITextField)
    func apply()
    func reset()
    func getPickerView() -> ToolbarPickerView
}

class PreferencesAdapter: NSObject {

    fileprivate let preferencesTableView: UITableView
    fileprivate weak var delegate: PreferencesAdapterDelegate?
        
    var dataSource:[String] = ["Select Default Role", "Select Photography Type", "", "", "Printer installed", "Plugin installed"] {
        didSet {
            self.preferencesTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: PreferencesAdapterDelegate) {
        self.preferencesTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.preferencesTableView.delegate = self
        self.preferencesTableView.dataSource = self
        
        let footerView = registerFooterView()
        self.preferencesTableView.tableFooterView = footerView
        
        self.registerCells()
    }
}

fileprivate extension PreferencesAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let summaryCell = UINib.init(nibName: "PreferencesTableViewCell", bundle: Bundle.main)
        self.preferencesTableView.register(summaryCell, forCellReuseIdentifier: "PreferencesTableViewCell")
        
    }
    
    func registerFooterView() -> UIView {
        let footerView = Bundle.main.loadNibNamed("PreferencesFooterCell", owner: self, options: nil)?[0] as! PreferencesFooterCell
        footerView.delegate = self
        
        return footerView
    }
}

extension PreferencesAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PreferencesTableViewCell.self), for: indexPath) as! PreferencesTableViewCell
        cell.delegate = self
        let data = self.dataSource[indexPath.row]
        cell.set(data: data, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
}

extension PreferencesAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            self.delegate?.didTapOnRow(indexPath: indexPath)
        }
    }
}

extension PreferencesAdapter: PreferencesFooterCellDelegate {
    func apply() {
        self.delegate?.apply()
    }
}

extension PreferencesAdapter: PreferencesTableViewCellDelegate {
    
//    func radioButtonSelected(button: RadioButton) {
//        self.delegate?.radioButtonSelected(button: button)
//    }
    
    func textFieldEndEditing(textField: UITextField) {
        self.delegate?.textFieldEndEditing(textField: textField)
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.delegate?.getPickerView() ?? ToolbarPickerView()
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
}
