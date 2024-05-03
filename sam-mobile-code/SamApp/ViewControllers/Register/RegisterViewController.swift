//
//  RegisterViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 18/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol RegisterView: BaseProtocol {
    func userRegistered(apiKey: String, message: String, code: Int)
}

class RegisterViewController: BaseScrollViewController {

    @IBOutlet weak var registerTableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate var registerAdapter: RegisterAdapter!
    fileprivate var registerPresenter: RegisterPresenterProtocol!
    
    fileprivate var pickerAdapter: PickerViewAdapter!
    fileprivate let pickerView = ToolbarPickerView()
    
    var valueDict: [String: Any] = [:]
    var selectedTextField: UITextField?
    var mobileNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        //self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: (8*88) + CGFloat(height + 55))
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 24))
        let titleLabel = UILabel(frame: view.frame)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.tofinoMediumEighteen()
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("REGISTER", comment: "")
        view.addSubview(titleLabel)
        self.navigationItem.titleView = view
        
        configureView()
        setupAdapter()
        setupPresenter()
    }

    class func viewController() -> RegisterViewController {
        let vc = RegisterViewController.instantiate(fromStoryboard: .Main)
        return vc
    }
    
    func getKey(titleLabel: String) -> String {
        switch titleLabel {
            case "Client Name":
                return "client_name"
            case "Client Location":
                return "client_location"
            case "Full Name":
                return "full_name"
            case "Email":
                return "email"
            case "Mobile Number":
                return "mobile"
            case "Location":
                return "user_location"
            case "Role":
                return "role"
            default:
                return ""
        }
    }
    
    func sendOTP() {
        LocalHelper.shared.sendOTP(toMobile: mobileNumber, success: { (data, json) in
            DispatchQueue.main.async {
                let vc = VerifyOTPViewController.instantiate(fromStoryboard: .Main)
                vc.delegate = self
                vc.mobileNumber = self.mobileNumber
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }) { (error) in

        }
    }
    
    @IBAction func registerButtonCliced(_ sender: UIButton) {

        valueDict = ["client_name": "", "client_location": "", "email": "", "full_name": "", "mobile": "", "user_location": "", "role": "", "device_id": "", "device_type": "ios"]
        
        for dict in self.registerAdapter.dataSource {
            if dict["value"]?.isEmpty == true {
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

                let alert = UIAlertController(title: "Message", message: "Please fill all the fields", preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            valueDict[getKey(titleLabel: dict["title"] ?? "")] = dict["value"]
        }
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            valueDict["device_id"] = uuid
        }
        
        sendOTP()
        //self.registerPresenter.register(withUserInfo: valueDict)
    }
}

fileprivate extension RegisterViewController {
    
    func configureView() {
        
        registerButton.makeRoundCorner(22)
    }
    
    func setupAdapter() {
        self.registerAdapter = RegisterAdapter(tableView: self.registerTableView, delegate: self)
        self.registerTableView.dataSource = self.registerAdapter
        
        self.pickerAdapter = PickerViewAdapter(pickerView: self.pickerView, delegate: self)
        self.pickerView.dataSource = self.pickerAdapter
      
        self.pickerAdapter.itemList = [PHOTOGRAPHER, STYLIST, STUDIO_MANAGER, OFFICE_ASSISTANT, ADMINISTRATOR, CLIENT_USER]
    }
    
    func setupPresenter() {
        let interactor = RegisterInteractor(networkClient: NetworkingClient())
        self.registerPresenter = RegisterPresenter(registerInteractor: interactor, registerView: self)
    }
}

extension RegisterViewController: RegisterView {
    func showActivityIndicator(withMessage message: String) {
            
    }
    
    func hideActivityIndicator() {
        
    }
    
    func userRegistered(apiKey: String, message: String, code: Int) {
        
        UserDefaults.standard.set(true, forKey: IS_REGISTERED)
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            //self.navigationController?.popViewController(animated: true)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateInitialViewController() as? UINavigationController
            
            if #available(iOS 13.0, *) {
                guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else {
                    return
                }
                sceneDelegate.window?.rootViewController = viewController
            }
            else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                appDelegate.window?.rootViewController = viewController
            }
        }
    }
    
}

extension RegisterViewController: RegisterAdapterDelegate {
    func getPickerView() -> ToolbarPickerView {
        return self.pickerView
    }
    
    func textFieldEndEditing(textField: CustomTextField) {
        
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        self.selectedTextField = textField
    }
}

extension RegisterViewController: PickerViewAdapterDelegate {
    func didTapOnRow(index: Int) {
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
    }
    
    func didTapDone(index: Int) {
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
        var dict = self.registerAdapter.dataSource[selectedTextField?.tag ?? 0]
        dict["value"] = selectedTextField?.text
        self.registerAdapter.dataSource[selectedTextField?.tag ?? 0] = dict
        self.selectedTextField?.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.selectedTextField?.resignFirstResponder()
        self.selectedTextField?.text = nil
    }
}

extension RegisterViewController: RegisterCellDelegate {
    
    func updateRegisterationDict(textField: UITextField) {
        var dict = self.registerAdapter.dataSource[textField.tag]
        dict["value"] = textField.text
        self.registerAdapter.dataSource[textField.tag] = dict
        if textField.tag == 4 {
            mobileNumber = textField.text ?? ""
        }
    }
    
    func textFieldBeginEditing(textField: UITextField) {
        if textField.tag == 6 {
            self.selectedTextField = textField
        }
    }
    
    func showPickerView() -> ToolbarPickerView {
        return self.getPickerView()
    }
}

extension RegisterViewController: VerifyOTPViewControllerDelegate {
    func done() {

        self.registerPresenter.register(withUserInfo: valueDict)
    }
}
