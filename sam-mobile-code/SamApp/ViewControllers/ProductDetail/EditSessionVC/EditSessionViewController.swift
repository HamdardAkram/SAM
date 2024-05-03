//
//  EditSessionViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 28/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol EditSessionView: BaseProtocol {
    func sessionEdited(productInfo: ProductDetails, message: String, code: Int)
}

protocol EditSessionViewDelegate: class {
    func updateProductPageFromSessionEdit()
}

class EditSessionViewController: UIViewController {

    @IBOutlet weak var sessionTableView: UITableView!
    
    fileprivate var editSessionPresenter: EditSessionPresenterProtocol!
    fileprivate var editSessionAdapter: EditSessionAdapter!
    fileprivate var pickerAdapter: PickerViewAdapter!
    fileprivate let pickerView = ToolbarPickerView()
    
    weak var delegate:EditSessionViewDelegate?
    var product: ProductData?
    var oldSessionObject: ProductSession?
    var newSessionDict: [String: Any]?
    
    var selectedTextField: UITextField?
    var reasonId: Int = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("EDIT_SESSION", comment: "")
     
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        saveButton.tintColor = UIColor.samRed()
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClicked))
        cancelButton.tintColor = UIColor.samRed()
        
        self.navigationItem.leftBarButtonItem = cancelButton
        
        setupAdapter()
        setupPresenter()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showAlertWithMessage(message: String) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateInput() -> Bool {
        var isShotDone: Bool = false
        var isDoingScanOut: Bool = false
        
        if self.editSessionAdapter.sessionObject?.scan_out_date.Value.isEmpty == false {
            if self.editSessionAdapter.sessionObject?.scan_out_by.isEmpty == true {
                showAlertWithMessage(message: "Plz fill scan out By field")
                return false
            }
            else {
                isDoingScanOut = true
            }
        }

        if isDoingScanOut == true {
            //check for shot done by at least one of these (photo, model, mannequin date) OR one reason with < 100 code.
            if self.editSessionAdapter.sessionObject?.photo_still_date.Value.isEmpty == false {
                if self.editSessionAdapter.sessionObject?.still_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.still_stylist_name.isEmpty == true {
                    //plz fill by and stylist name field
                    showAlertWithMessage(message: "Plz fill By and Still stylist name field")
                    return false
                }
                else {
                    isShotDone = true
                }
            }
            if self.editSessionAdapter.sessionObject?.photo_model_date.Value.isEmpty == false {
                
                if self.editSessionAdapter.sessionObject?.model_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.model_stylist_name.isEmpty == true {
                    //plz fill by and model stylist name field
                    showAlertWithMessage(message: "Plz fill By and Model stylist name field")
                    return false
                }
                else {
                    isShotDone = true
                }
            }
            if self.editSessionAdapter.sessionObject?.photo_mannequin_date.Value.isEmpty == false {
                if self.editSessionAdapter.sessionObject?.mannequin_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.mannequin_stylist_name.isEmpty == true {
                    //plz fill by and mannequin stylist name field
                    showAlertWithMessage(message: "Plz fill By and Mannequin stylist name field")
                    return false
                }
                else {
                    isShotDone = true
                }
            }

            if self.editSessionAdapter.sessionObject?.photo_still_date.Value.isEmpty == true && self.editSessionAdapter.sessionObject?.photo_model_date.Value.isEmpty == true && self.editSessionAdapter.sessionObject?.photo_mannequin_date.Value.isEmpty == true {
                isShotDone = false
            }
            
            if reasonId < 3 {
                isShotDone = true
            }

            if isShotDone == true && reasonId > 3 {
                isShotDone = false
            }
            if isShotDone == false {
                //show message scan out not allowed because no shot done yet
                showAlertWithMessage(message: "No shot done yet so scan out will not be allowed")
                return false
            }
        }
        else {
            if self.editSessionAdapter.sessionObject?.photo_still_date.Value.isEmpty == false {
                if self.editSessionAdapter.sessionObject?.still_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.still_stylist_name.isEmpty == true {
                    //plz fill by and stylist name field
                    showAlertWithMessage(message: "Plz fill By and Still stylist name field")
                    return false
                }
            }

            if self.editSessionAdapter.sessionObject?.photo_model_date.Value.isEmpty == false {
                if self.editSessionAdapter.sessionObject?.model_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.model_stylist_name.isEmpty == true {
                    //plz fill by and model stylist name field
                    showAlertWithMessage(message: "Plz fill By and Model stylist name field")
                    return false
                }
            }

            if self.editSessionAdapter.sessionObject?.photo_mannequin_date.Value.isEmpty == false {
                if self.editSessionAdapter.sessionObject?.mannequin_photographer.isEmpty == true || self.editSessionAdapter.sessionObject?.mannequin_stylist_name.isEmpty == true {
                    //plz fill by and mannequin stylist name field
                    showAlertWithMessage(message: "Plz fill By and Mannequin stylist name field")
                    return false
                }
            }
            if self.editSessionAdapter.sessionObject?.photo_still_date.Value.isEmpty == true && self.editSessionAdapter.sessionObject?.photo_model_date.Value.isEmpty == true && self.editSessionAdapter.sessionObject?.photo_mannequin_date.Value.isEmpty == true {
                showAlertWithMessage(message: "Plz fill at least one shot")
                return false
            }
        }
        return true
    }
    
    @objc func saveButtonClicked() {
        
        if validateInput() == false {
            return
        }
        
        var sessionList =  [[String: Any]]()
        var sessionBeforeModificationDict: [String: Any] = [:]
        var modifiedSessionDict: [String: Any] = [:]
                
        let jsonEncoder = JSONEncoder()
        do {

            let jsonData = try jsonEncoder.encode(oldSessionObject)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            guard let sessionDict = convertToDictionary(text: jsonString!) else {
                return
            }
            sessionBeforeModificationDict = sessionDict
        }
        catch {
        }

        do {
            let jsonData = try jsonEncoder.encode(self.editSessionAdapter.sessionObject)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            guard let sessionDict = convertToDictionary(text: jsonString!) else {
                return
            }
            modifiedSessionDict = sessionDict
        }
        catch {
        }

        for (key, value) in modifiedSessionDict  {
            if let val = value as? String {
                if val.isEmpty == true {
                    modifiedSessionDict.removeValue(forKey: key)
                }
            }
        }

        if let prod = product {
            for session in prod.sessions {
                do {
                    let jsonData = try jsonEncoder.encode(session)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    print("JSON String : " + jsonString!)
                    guard var sessionDict = convertToDictionary(text: jsonString!) else {
                        return
                    }
                    if session.product_session_id == oldSessionObject?.product_session_id {
                        sessionList.append(modifiedSessionDict)
                    }
                    else {
                        for (key, value) in sessionDict  {
                            if let val = value as? String {
                                if val.isEmpty == true {
                                    sessionDict.removeValue(forKey: key)
                                }
                            }
                        }
                        sessionList.append(sessionDict)
                    }
                }
                catch {

                }
            }
        }
        
        if let productId = product?._id {
            let user = getLoggedInUser()
            let dict: [String: Any] = ["user_name": user?.data?.full_name ?? "", "client_name": user?.client_name ?? "", "product_id": productId, "sessions": sessionList, "session_before_modification": sessionBeforeModificationDict, "modified_session": modifiedSessionDict]
            print(dict)
            self.editSessionPresenter.editSession(productInfo: dict)
        }
    }

    @objc func cancelButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}

fileprivate extension EditSessionViewController {
    
    func setupAdapter() {
        self.editSessionAdapter = EditSessionAdapter(tableView: self.sessionTableView, delegate: self)
        self.sessionTableView.dataSource = self.editSessionAdapter
        
        self.pickerAdapter = PickerViewAdapter(pickerView: self.pickerView, delegate: self)
        self.pickerView.dataSource = self.pickerAdapter
        
        self.pickerAdapter.itemList = [SELECT_REASON, DAMAGED_PRODUCTS, WRONG_SIZE, PRODUCTS_TO_RETURN, HELD_FOR_MODEL, WRONG_COLOR]
        
        self.editSessionAdapter.sessionObject = self.oldSessionObject
    }
    
    func setupPresenter() {
        let interactor = EditSessionInteractor(networkClient: NetworkingClient())
        self.editSessionPresenter = EditSessionPresenter(editSessionInteractor: interactor, editSessionView: self)
    }
}

extension EditSessionViewController: EditSessionAdapterDelegate {
    
    func billableButtonClicked(button: UIButton) {
        let str = (button.isSelected == true) ? "1" : "0"
        self.editSessionAdapter.sessionObject?.billable = VariacType.string(str)
    }
    
    func slaButtonClicked(button: UIButton) {
        let str = (button.isSelected == true) ? "1" : "0"
        self.editSessionAdapter.sessionObject?.sla = VariacType.string(str)
    }
    
    func textFieldEndEditing(textField: CustomTextField) {
        
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        self.selectedTextField = textField
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.pickerView
    }
}

extension EditSessionViewController: PickerViewAdapterDelegate {
    func didTapOnRow(index: Int) {
        if self.selectedTextField?.tag != 4 {
            reasonId = index
            self.editSessionAdapter.sessionObject?.wrong_code = String(reasonId)
        }
        else {
            self.editSessionAdapter.sessionObject?.model_name = self.pickerAdapter.itemList[index]
        }
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
    }
    
    func didTapDone(index: Int) {
        if self.selectedTextField?.tag != 4 {
            reasonId = index
            self.editSessionAdapter.sessionObject?.wrong_code = String(reasonId)
        }
        else {
            self.editSessionAdapter.sessionObject?.model_name = self.pickerAdapter.itemList[index]
        }
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
        self.selectedTextField?.resignFirstResponder()
    }
    
    func didTapCancel() {
        if self.selectedTextField?.tag != 4 {
            self.editSessionAdapter.sessionObject?.wrong_code = "0"
        }
        else {
            self.editSessionAdapter.sessionObject?.model_name = ""
        }
        self.selectedTextField?.resignFirstResponder()
        self.selectedTextField?.text = nil
    }
}

extension EditSessionViewController: EditSessionView {
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
    
    func sessionEdited(productInfo: ProductDetails, message: String, code: Int) {
        self.delegate?.updateProductPageFromSessionEdit()
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditSessionViewController: EditSessionCellDelegate {
    func updateSessionDict(textField: UITextField, date: Double, forCell: EditSessionCell) {
        switch forCell.tag {
        case 0:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.scan_in_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.scan_in_by = textField.text ?? ""
            }
        case 1:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.photo_still_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.still_photographer = textField.text ?? ""
            }
        case 2:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.photo_model_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.model_photographer = textField.text ?? ""
            }
        case 3:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.photo_mannequin_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.mannequin_photographer = textField.text ?? ""
            }
        case 4:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.copywrite_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.copywriter_name = textField.text ?? ""
            }
        case 5:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.video_shot_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.videography_by = textField.text ?? ""
            }
        case 6:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.scan_out_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.scan_out_by = textField.text ?? ""
            }
        case 7:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.upload_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.uploaded_by = textField.text ?? ""
            }
        case 8:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.still_upload_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.still_uploaded_by = textField.text ?? ""
            }
        case 9:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.model_upload_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.model_uploaded_by = textField.text ?? ""
            }
        case 10:
            if textField.tag == 101 {
                if date > 0 {
                    self.editSessionAdapter.sessionObject?.mannequin_upload_date = VariacType.double(date)
                }
            }
            else {
                self.editSessionAdapter.sessionObject?.mannequin_uploaded_by = textField.text ?? ""
            }
        default:
            print("end")
        }
    }
}

extension EditSessionViewController: EditSessionCell2Delegate {
    
    func updateSessionDictForSectionTwo(textField: UITextField, forCell: EditSessionCell2) {
        switch forCell.tag {
        case 0:
            self.editSessionAdapter.sessionObject?.still_stylist_name = textField.text ?? ""
        case 1:
            self.editSessionAdapter.sessionObject?.model_stylist_name = textField.text ?? ""
        case 2:
            self.editSessionAdapter.sessionObject?.mannequin_stylist_name = textField.text ?? ""
        case 3:
            self.editSessionAdapter.sessionObject?.video_stylist_name = textField.text ?? ""
        case 4:
            self.editSessionAdapter.sessionObject?.model_name = textField.text ?? ""
        default:
            print("end")
        }
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        if textField.tag == 4 {
            self.selectedTextField = textField
            self.pickerAdapter.itemList = ["Test Model", "Sample Model"]
        }
    }
    
    func showPickerView() -> ToolbarPickerView {
        return self.getPickerView() 
    }
}

extension Dictionary where Key == String, Value == Any {

    var trimmingNullValues: [String: Any] {
        var copy = self
        forEach { (key, value) in
            if value == nil {
                copy.removeValue(forKey: key)
            }
        }
        return copy as [Key: Optional<Value>] as [String : Any]
    }
}
