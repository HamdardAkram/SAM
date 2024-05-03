//
//  VerifyOTPViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 19/12/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol VerifyOTPViewControllerDelegate: AnyObject {
    func done()
}

class VerifyOTPViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var otpView: UIView!
    
    var isFromLogin: Bool = false
    var mobileNumber: String = ""
    var delegate: VerifyOTPViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.otpView.makeBorder(1.0, color: UIColor.samGray())
        self.otpView.makeRoundCorner(4)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        if isFromLogin {
            let user = getLoggedInUser()
            if (otpTextField.text ?? "").contains("\(user?.otp ?? 0)") {
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "OTP_Verified")
                defaults.synchronize()
                delegate?.done()
            }
            else {
                self.showOkAlert("Please enter correct otp")
            }
            return
        }
        LocalHelper.shared.verifyOTP(mobile: mobileNumber, otp: otpTextField.text ?? "", success: { [weak self] (data, json) in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.delegate?.done()
            }
            
        }) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
