//
//  EditSessionAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol EditSessionAdapterDelegate: class {
    func billableButtonClicked(button: UIButton)
    func slaButtonClicked(button: UIButton)
    func getPickerView() -> ToolbarPickerView
    
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
}

class EditSessionAdapter: NSObject {

    static let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    fileprivate let sessionTableView: UITableView
    fileprivate weak var delegate: EditSessionAdapterDelegate?
    
    var headerView: EditSessionHeaderView?
    
    var sessionObject: ProductSession? {
        didSet {
            headerView?.setData(session: self.sessionObject)
            //self.sessionTableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: EditSessionAdapterDelegate) {
        self.sessionTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.sessionTableView.delegate = self
        self.sessionTableView.dataSource = self
        self.sessionTableView.tableHeaderView = getHeaderView()
        //self.sessionTableView.tableFooterView = getFooterView()

        self.registerCells()
    }
    
    func getHeaderView() -> UIView {
        headerView = Bundle.main.loadNibNamed("EditSessionHeaderView", owner: self, options: nil)?.last as? EditSessionHeaderView
        guard let view = headerView else {
            return UIView()
        }
        view.headerDelegate = self
        view.contentView.backgroundColor = UIColor.black
        return view
    }
    
    func getFooterView() -> UIView {
        let footerView = Bundle.main.loadNibNamed("DetailFooterView", owner: self, options: nil)?.last
        guard let view = footerView as? DetailFooterView else {
            return UIView()
        }
        //view.footerDelegate = self
        view.contentView.backgroundColor = UIColor.black
        return view
    }
    
    func getDictForCell(index: Int) -> [String: String] {
        switch index {
        case 0:
            return ["title": SCAN_IN_DATE, "date": sessionObject?.scan_in_date.Value ?? "", "by": sessionObject?.scan_in_by ?? ""]
        case 1:
            return ["title": "Photo (Still) date", "date": sessionObject?.photo_still_date.Value ?? "", "by": sessionObject?.still_photographer ?? ""]
        case 2:
            return ["title": "Photo (Model) date", "date": sessionObject?.photo_model_date.Value ?? "", "by": sessionObject?.model_photographer ?? ""]
        case 3:
            return ["title": "Photo (Mann) date", "date": sessionObject?.photo_mannequin_date.Value ?? "", "by": sessionObject?.mannequin_photographer ?? ""]
        case 4:
            return ["title": "Copywriting date", "date": sessionObject?.copywrite_date.Value ?? "", "by": sessionObject?.copywriter_name ?? ""]
        case 5:
            return ["title": "Video date", "date": sessionObject?.video_shot_date.Value ?? "", "by": sessionObject?.videography_by ?? ""]
        case 6:
            return ["title": SCAN_OUT_DATE, "date": sessionObject?.scan_out_date.Value ?? "", "by": sessionObject?.scan_out_by ?? ""]
        case 7:
            return ["title": UPLOAD_DATE, "date": sessionObject?.photo_date.Value ?? "", "by": sessionObject?.uploaded_by ?? ""]
        case 8:
            return ["title": STILL_UPLOAD_DATE, "date": sessionObject?.still_upload_date.Value ?? "", "by": sessionObject?.still_uploaded_by ?? ""]
        case 9:
            return ["title": MODEL_UPLOAD_DATE, "date": sessionObject?.model_upload_date.Value ?? "", "by": sessionObject?.model_uploaded_by ?? ""]
        case 10:
            return ["title": MANNAQUIN_UPLOAD_DATE, "date": sessionObject?.mannequin_upload_date.Value ?? "", "by": sessionObject?.mannequin_uploaded_by ?? ""]
        default:
            print("end")
        }
        return [:]
    }
    
    func getDictForSectionTwoCell(index: Int) -> [String: String] {
        switch index {
        case 0:
            return ["title": "Still Stylist", "value": sessionObject?.still_stylist_name ?? ""]
        case 1:
            return ["title": "Model Stylist", "value": sessionObject?.model_stylist_name ?? ""]
        case 2:
            return ["title": "Mannequin Stylist", "value": sessionObject?.mannequin_stylist_name ?? ""]
        case 3:
            return ["title": "Video Stylist", "value": sessionObject?.video_stylist_name ?? ""]
        case 4:
            return ["title": "Model", "value": sessionObject?.model_name ?? ""]
        default:
            print("end")
        }
        return [:]
    }
}

fileprivate extension EditSessionAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let shopCell = UINib.init(nibName: "EditSessionCell", bundle: Bundle.main)
        self.sessionTableView.register(shopCell, forCellReuseIdentifier: "EditSessionCell")
        
        let sectionTwoCell = UINib.init(nibName: "EditSessionCell2", bundle: Bundle.main)
        self.sessionTableView.register(sectionTwoCell, forCellReuseIdentifier: "EditSessionCell2")
    }
}

extension EditSessionAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 11 : 5
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditSessionCell.self), for: indexPath) as! EditSessionCell
            let dict = getDictForCell(index: indexPath.row)
            cell.tag = indexPath.row
            cell.delegate = self.delegate as? EditSessionCellDelegate
            cell.setData(data: dict)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditSessionCell2.self), for: indexPath) as! EditSessionCell2
            
            let dict = getDictForSectionTwoCell(index: indexPath.row)
            cell.tag = indexPath.row
            cell.delegate = self.delegate as? EditSessionCell2Delegate
            cell.setData(data: dict, session: sessionObject)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 128 : 54
    }
}

extension EditSessionAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.delegate?.didTapOnRow(indexPath: indexPath)
    }
}

extension EditSessionAdapter: EditSessionAdapterDelegate {
    
    func textFieldEndEditing(textField: CustomTextField) {
        
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
}

extension EditSessionAdapter: EditSessionHeaderViewDelegate {
    func billableButtonClicked(button: UIButton) {
        self.delegate?.billableButtonClicked(button: button)
    }
        
    func slaButtonClicked(button: UIButton) {
        self.delegate?.slaButtonClicked(button: button)
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.delegate?.getPickerView() ?? ToolbarPickerView()
    }
}
