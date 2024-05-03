//
//  UIViewController+ErrorHandling.swift
//  SamApp
//
//  Created by Akram on 13/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(_ msg: String) {
        let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showOkAlertWithActionHandler(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void) {
        let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            return handler(true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTitleAndActions(title: String, actions:[String], handler:@escaping (_ clickedIndex: Int) -> Void) {
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        for title in actions {
            
            let action  = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                //Call back fall when user clicked
                let index = actions.firstIndex(of: alertAction.title!)
                guard let selectedIndex = index else {
                    handler(0)
                    return
                }
                handler(selectedIndex+1)
            })
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .destructive, handler: { (action) -> Void in })
        alert.addAction(cancel)
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor.gray  // change text color of the buttons
        alert.view.backgroundColor = UIColor.lightGray  // change background color
        alert.view.layer.cornerRadius = 25   // change corner radius

        present(alert, animated: true, completion: nil)
    }
    
    func showOkCancelAlertWithAction(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void) {
        let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            return handler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return handler(false)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
