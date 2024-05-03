//
//  UIScrollView+Loading.swift
//  SamApp
//
//  Created by Akram on 12/03/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func showLoading(withMessage message: String) {
        
        let viewForActivityIndicator = UIView()
        viewForActivityIndicator.tag = 1000
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: self.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.clear
        
        self.addSubview(viewForActivityIndicator)
        
        let loadingIndicator = UIActivityIndicatorView.init()
        if #available(iOS 13, *) {
            loadingIndicator.style = .medium
        }
        else {
            loadingIndicator.style = .white
        }
        loadingIndicator.center = viewForActivityIndicator.center
        
        viewForActivityIndicator.addSubview(loadingIndicator)
        
        let loadingTextLabel = UILabel()
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = message
        loadingTextLabel.font = UIFont(name: "Lato", size: 14)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: loadingIndicator.center.x, y: loadingIndicator.center.y + 30)
        
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        self.viewWithTag(1000)?.removeFromSuperview()
    }
}
