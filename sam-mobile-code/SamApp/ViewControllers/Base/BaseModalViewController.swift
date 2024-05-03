//
//  BaseModalViewController.swift
//  SamApp
//
//  Created by Akram on 12/03/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class BaseModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.definesPresentationContext = true
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
    }
}
