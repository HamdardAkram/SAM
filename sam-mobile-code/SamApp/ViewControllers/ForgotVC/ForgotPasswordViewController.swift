//
//  ForgotPasswordViewController.swift
//  SamApp
//
//  Created by Akram on 19/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ForgotView: BaseView {
    func resetRequsetDone(json: JSON?)
    func updatePasswordDone(json: JSON?)
    func showActivityIndicator(withMessage message: String)
    func hideActivityIndicator()
}

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var forgotPresenter: ForgotPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = NSLocalizedString("FORGOT_PASSWORD", comment: "")
        //self.headerLabel.setFontMetrics(font: UIFont.thirteenRegular())
        //sendButton.titleLabel?.setFontMetrics(font: UIFont.fourteenRegular())
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
        
        //self.emailTextField.textColor = UIColor.labelColor
        self.configureView()
        
        self.setupPresenter()
    }

    class func viewController() -> ForgotPasswordViewController {
        let vc = ForgotPasswordViewController.instantiate(fromStoryboard: .Main)
        
        return vc
    }
    
    func showResetPopup() {
        let alertVC = ResetAlertViewController.viewController()
        alertVC.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        alertVC.moveToLogin = {
            self.navigationController?.popViewController(animated: true)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func onSendResetLinkClick(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
                    self.passwordViewHeightConstraint.constant = 44
                }, completion: { (state) in
                    
                    self.sendButton.setTitle("RESET PASSWORD", for: .normal)
                })
        
        let emailStr: String = (emailTextField.text?.trim()) ?? ""
        if (emailStr.isEmpty) {
            self.showOkAlert(NSLocalizedString("ENTER_EMAIL", comment: ""))
            return
        }
        
        if sendButton.titleLabel?.text == "GET PASSWORD" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let tokenString = dateFormatter.string(from: Date()).md5
            self.forgotPresenter.resetPassword(withUserInfo: ["email": emailStr, "token": tokenString])
        }
        else {
            guard let password = passwordTextField.text?.md5 else {
                return
            }
            self.forgotPresenter.updatePassword(withUserInfo: ["email": emailStr, "token": "asghasgdgsadagds", "user_pass": password])
        }
    }
}

fileprivate extension ForgotPasswordViewController {
    
    func configureView() {
        emailView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        emailView.makeBorder(1.0, color: UIColor.samBorderGray())
        passwordView.makeBorder(1.0, color: UIColor.samBorderGray())
        
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 22
    }
    
    func setupPresenter() {
        let interactor = ForgotInteractor(networkClient: NetworkingClient())
        self.forgotPresenter = ForgotPresenter(forgotInteractor: interactor, forgotView: self)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ForgotPasswordViewController: ForgotView {
    func resetRequsetDone(json: JSON?) {
        
        showResetPopup()
//        UIView.animate(withDuration: 0.3, animations: {
//            self.passwordViewHeightConstraint.constant = 44
//        }, completion: { (state) in
//            
//            self.sendButton.setTitle("RESET PASSWORD", for: .normal)
//        })
    }
    
    func updatePasswordDone(json: JSON?) {
        showResetPopup()
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
        
    func hideActivityIndicator() {
        self.hideLoading()
    }
}
