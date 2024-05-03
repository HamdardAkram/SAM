//
//  PickerViewAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol PickerViewAdapterDelegate: class {
    func didTapOnRow(index: Int)
    func didTapDone(index: Int)
    func didTapCancel()
}

class PickerViewAdapter: NSObject {

    fileprivate let pickerView: ToolbarPickerView
    fileprivate weak var delegate: PickerViewAdapterDelegate?
        
    var itemList:[String] = ["Photographer", "Model", "Stylist on set", "Model on set", "Printer installed", "Plugin installed"] {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    
     init(pickerView: ToolbarPickerView, delegate: PickerViewAdapterDelegate) {
        self.pickerView = pickerView
        self.delegate = delegate
        
        super.init()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
    }
}

extension PickerViewAdapter: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemList[row]
    }
}

extension PickerViewAdapter: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.selectedTextField?.text = itemList[row]
        self.delegate?.didTapOnRow(index: row)
    }
}

extension PickerViewAdapter: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.delegate?.didTapDone(index: row)
        
    }

    func didTapCancel() {
        self.delegate?.didTapCancel()
        
    }
}
