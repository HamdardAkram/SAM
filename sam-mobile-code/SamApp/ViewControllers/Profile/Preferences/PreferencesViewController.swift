//
//  PreferencesViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import MBRadioButton

protocol PreferencesView: BaseView {
    func managerPreferences(prefs: ModelManagerPreference, message: String)
}

class PreferencesViewController: BaseViewController {

    @IBOutlet weak var preferencesTableView: UITableView!
    
    fileprivate var preferencesAdapter: PreferencesAdapter!
    fileprivate var pickerAdapter: PickerViewAdapter!
    
    fileprivate let pickerView = ToolbarPickerView()
    
    var selectedTextField: UITextField?
    var comingFromScanProduct: Bool = false
    
    var preferencesDict: [String: Any] = [:]
    var roleAndtype: String = ""
    var managerPrefs: ModelManagerPreference?
    var selectedPrefData: ModelManagerPreferenceData?
    
    fileprivate var prefsPresenter: PreferencePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("SET_PREFERENCES", comment: "")
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonClicked))
        self.navigationItem.rightBarButtonItem = resetButton
        
        preferencesTableView.clipsToBounds = true
        preferencesTableView.layer.cornerRadius = 10.0
        
        if let dict = UserDefaults.standard.value(forKey: USER_PREFERENCES) as? [String: Any] {
            preferencesDict = dict
        }
        setupAdapter()
        setupPresenter()
        let user = getLoggedInUser()
        if user?.isModelManager ?? false {
            prefsPresenter.getModelManagerPreferences(search: "", client: user?.client_name ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        comingFromScanProduct = false
    }
    
    @objc func resetButtonClicked() {
        
    }
}

fileprivate extension PreferencesViewController {
    func setupAdapter() {
        self.preferencesAdapter = PreferencesAdapter(tableView: self.preferencesTableView, delegate: self)
        self.preferencesTableView.dataSource = self.preferencesAdapter
        
        self.pickerAdapter = PickerViewAdapter(pickerView: self.pickerView, delegate: self)
        self.pickerView.dataSource = self.pickerAdapter
    }
    
    func setupPresenter() {
        let interactor = PreferenceInteractor(networkClient: NetworkingClient())
        self.prefsPresenter = PreferencePresenter(preferenceInteractor: interactor, prefsResultView: self)
    }
}

extension PreferencesViewController: PreferencesAdapterDelegate {
    
    func didTapOnRow(indexPath: IndexPath) {
        
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        self.pickerAdapter.itemList.removeAll()
        switch textField.tag {
        case 0:
            roleAndtype = ROLE
            self.selectedTextField = textField
            self.pickerAdapter.itemList = ["Select Default Role", "Copywriter", "Photographer", "Retoucher", "Stylist", "Videographer"]
        case 1:
            self.selectedTextField = textField
            roleAndtype = PHOTOGRAPHY_TYPE
            self.pickerAdapter.itemList = ["Select Photography Type", "Stills", "Model", "Mannequin"]
        case 3:
            self.selectedTextField = textField
            self.pickerAdapter.itemList = self.managerPrefs?.data.map({ $0.model_name }) ?? []
        default:
            print("end")
        }
    }
    
    func textFieldEndEditing(textField: UITextField) {
    
        self.pickerAdapter.itemList.removeAll()
        switch textField.tag {
        case 0:
            preferencesDict[ROLE] = textField.text
        case 1:
            preferencesDict[PHOTOGRAPHY_TYPE] = textField.text
        case 2:
            preferencesDict[STYLIST] = textField.text
        case 3:
            preferencesDict[MODEL] = textField.text
            self.selectedPrefData?._id = ""
            self.selectedPrefData?.clients = []
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.selectedPrefData)
                preferencesDict[MODEL_DATA] = data
            } catch {
                // Fallback
            }
            
        default:
            print("end")
        }
    }
    
//    func radioButtonSelected(button: RadioButton) {
//        if button.tag == 4 {
//            preferencesDict[PRINTER_INSTALLED] = button.titleLabel?.text == "Yes" ? true : false
//        }
//        else {
//            preferencesDict[PLUGIN_INSTALLED] = button.titleLabel?.text == "Yes" ? true : false
//        }
//    }
    
    func apply() {
        if let role = preferencesDict[ROLE] as? String {
            if role == "Select Default Role" {
                self.showOkAlert("Please select role")
                return
            }
        }
        else {
            self.showOkAlert("Please select role")
            return
        }
        if let role = preferencesDict[PHOTOGRAPHY_TYPE] as? String {
            if role == "Select Photography Type" {
                self.showOkAlert("Please select photography type")
                return
            }
        }
        else {
            self.showOkAlert("Please select photography type")
            return
        }
        UserDefaults.standard.set(preferencesDict, forKey: USER_PREFERENCES)
        UserDefaults.standard.synchronize()
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let alert = UIAlertController(title: "Message", message: "Preferences saved successfully", preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        if comingFromScanProduct == true {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.tabBarController?.selectedIndex = 2
        }
    }
    
    func reset() {
        
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.pickerView
    }
}

extension PreferencesViewController: PickerViewAdapterDelegate {
    func didTapOnRow(index: Int) {
        if index < self.pickerAdapter.itemList.count {
            self.selectedTextField?.text = self.pickerAdapter.itemList[index]
            if self.selectedTextField?.tag == 3 {
                self.selectedPrefData = self.managerPrefs?.data[index]
            }
        }
    }
    
    func didTapDone(index: Int) {
        if index < self.pickerAdapter.itemList.count {
            self.selectedTextField?.text = self.pickerAdapter.itemList[index]
            if self.selectedTextField?.tag == 3 {
                self.selectedPrefData = self.managerPrefs?.data[index]
            }
            self.selectedTextField?.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        self.selectedTextField?.resignFirstResponder()
        self.selectedTextField?.text = nil
    }
}

extension PreferencesViewController: PreferencesView {
    func showActivityIndicator(withMessage message: String) {
        self.preferencesTableView.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.preferencesTableView.hideLoading()
    }
    
    func managerPreferences(prefs: ModelManagerPreference, message: String) {
        self.managerPrefs = prefs
        self.preferencesTableView.reloadData()
    }
}
