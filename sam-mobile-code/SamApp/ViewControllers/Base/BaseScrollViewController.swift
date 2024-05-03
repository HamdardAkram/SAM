//
//  BaseListViewController.swift
//  SamApp
//
//  Created by Leonid Peancovsky on 19/02/2018.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

/*
 * This class is intended to handle content inset in scroll view on keyboard appearance/disappearance.
 * Subclass this class everytime you want to handle setting content inset on scroll view and override scrollView property
 */
class BaseScrollViewController: BaseViewController {
    
    // override this property in subsclass
    @IBOutlet var scrollView: UIScrollView!
    
    fileprivate var initialContentInset: UIEdgeInsets?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.initialContentInset == nil {
            self.initialContentInset = self.scrollView.contentInset
        }
    }
}

fileprivate extension BaseScrollViewController {
    // MARK: Setup Methods
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension BaseScrollViewController {
    // MARK: Keyboard Notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.setContentInset(forKeyboardHeight: keyboardFrame.size.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = self.initialContentInset ?? UIEdgeInsets.zero
    }
    
    fileprivate func setContentInset(forKeyboardHeight keyboardHeight: CGFloat) {
        var adjustedKeyboardHeight: CGFloat = keyboardHeight
        if #available(iOS 11.0, *) {
            adjustedKeyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom
        }
        
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = adjustedKeyboardHeight
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
}
