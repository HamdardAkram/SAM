//
//  BASignInViewController.swift
//  SamApp
//
//  Created by Akram on 06/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import AuthenticationServices
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

protocol SignInView: BaseView {
    func signInDone(user: User)
    func showActivityIndicator(withMessage message: String)
    func hideActivityIndicator()
}

class SignInViewController: BaseScrollViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var clientView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var clientTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    fileprivate var signInPresenter: SignInPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        emailTextField.tintColor = UIColor.systemBlue
        clientTextfield.tintColor = UIColor.systemBlue
        passwordTextfield.tintColor = UIColor.systemBlue
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter email address",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
        clientTextfield.attributedPlaceholder = NSAttributedString(string: "Enter client name",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Enter password",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        self.configureView()
        self.setupPresenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.signInPresenter = nil
    }
    
    func moveToSaleScreen() {
        let tabVC = UITabBarController.initailViewController(fromStoryboard: .Home)
        tabVC.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    @IBAction func hideShowPassword(_ sender: UIButton) {
        passwordTextfield.isSecureTextEntry = !passwordTextfield.isSecureTextEntry
    }
    @IBAction func onSignInButtonClick(_ sender: Any) {
        emailTextField.text = "pvats@packshot.com"//"hamdard.akram@gmail.com"//
        clientTextfield.text = "brownthomas_new"//ck_accessories
        passwordTextfield.text = "Peeyush@1111"
        let emailStr: String = (emailTextField.text?.trim()) ?? ""
        if (emailStr.isEmpty) {
            self.showOkAlert(NSLocalizedString("ENTER_EMAIL", comment: ""))
            return
        } else if (emailStr.isValidEmail() == false) {
            self.showOkAlert(NSLocalizedString("VALID_EMAIL", comment: ""))
            return
        }
        let clientStr: String = (clientTextfield.text?.trim()) ?? ""
        if clientStr.isEmpty {
            self.showOkAlert(NSLocalizedString("ENTER_CLIENT", comment: ""))
        }
        
        guard let md5Password = passwordTextfield.text?.md5 else {
            return
        }
        self.signInPresenter.signin(withUserInfo: ["email": emailStr, "client": clientStr, "user_pass": md5Password, "device": "mobile"])
        
    }
    
//    @IBAction func onRegisterButtonClicked(_ sender: Any) {
//        let registerVC = RegisterViewController.viewController()
//        self.navigationController?.pushViewController(registerVC, animated: true)
//    }
    
    @IBAction func onSignInWithFacebookClicked(_ sender: Any) {
    }
    
    @IBAction func onForgotPasswordClick(_ sender: Any) {
        let forgotVC = ForgotPasswordViewController.viewController()
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
}

fileprivate extension SignInViewController {
    // MARK: Setup Methods
    
    func configureView() {
        emailView.layer.cornerRadius = 3
        clientView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        
        emailView.makeBorder(1.0, color: UIColor.samRed())
        clientView.makeBorder(1.0, color: UIColor.samBorderGray())
        passwordView.makeBorder(1.0, color: UIColor.samBorderGray())
        
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 22
    }
    
    func setupPresenter() {
        let interactor = SignInInteractor(networkClient: NetworkingClient())
        self.signInPresenter = SignInPresenter(signInInteractor: interactor, signInView: self)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func resetFieldsBorder() {
        emailView.makeBorder(1.0, color: UIColor.samBorderGray())
        clientView.makeBorder(1.0, color: UIColor.samBorderGray())
        passwordView.makeBorder(1.0, color: UIColor.samBorderGray())
    }
    
    func setFieldsBorder(fieldId: Int) {
        switch fieldId {
        case 101:
            emailView.makeBorder(1.0, color: UIColor.samRed())
        case 102:
            clientView.makeBorder(1.0, color: UIColor.samRed())
        case 103:
            passwordView.makeBorder(1.0, color: UIColor.samRed())
        default:
            print("end")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        resetFieldsBorder()
        let nextTag = textField.tag
        setFieldsBorder(fieldId: nextTag)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setFieldsBorder(fieldId: textField.tag + 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetFieldsBorder()

        let nextTag = textField.tag + 1
        setFieldsBorder(fieldId: nextTag)
        
        let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) as UIResponder?

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false
    }
}

extension SignInViewController: SignInView {
    
    func signInDone(user: User) {
        if user.statusCode == 200 {
            let vc = VerifyOTPViewController.instantiate(fromStoryboard: .Main)
            vc.delegate = self
            vc.isFromLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.showOkAlert(user.message)
        }
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
}

extension SignInViewController: VerifyOTPViewControllerDelegate {
    func done() {

        moveToSaleScreen()
    }
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
