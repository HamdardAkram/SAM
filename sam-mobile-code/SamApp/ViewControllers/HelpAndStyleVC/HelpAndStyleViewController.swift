//
//  HelpAndStyleViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 12/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import WebKit

class HelpAndStyleViewController: UIViewController {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.black
        
        let url = URL(string: "")!
        self.webView.load(URLRequest(url: url))
        self.webView.allowsBackForwardNavigationGestures = true
    }

}

extension HelpAndStyleViewController: WKNavigationDelegate {
    
}
