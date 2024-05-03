//
//  ResetAlertViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 30/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ResetAlertViewController: BaseModalViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    var moveToLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alertView.clipsToBounds = true
        self.alertView.layer.cornerRadius = 16.0
        
        self.doneButton.clipsToBounds = true
        self.doneButton.layer.cornerRadius = 22.0
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewOnTap(tapGesture:)))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            self.dismiss(animated: true, completion: nil)
        }
        
    class func viewController() -> ResetAlertViewController {
        let resetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ResetAlertViewController.self)) as! ResetAlertViewController
        return resetVC
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.view)
        if self.alertView.frame.contains(touchPoint) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func dismissViewOnTap(tapGesture: UIGestureRecognizer) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        moveToLogin?()
        self.dismiss(animated: true, completion: nil)
    }
}
