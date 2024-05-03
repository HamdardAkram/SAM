//
//  ShareViewController.swift
//  SamApp
//
//  Created by Leonid Peancovsky on 26/04/2018.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class ShareViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupShareButton()
    }
    
    // override in subclasses
    var urlToShare: URL?
    
    @objc func didPressShare() {
        guard let url = self.urlToShare else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if self.traitCollection.userInterfaceIdiom == .pad {
            activityViewController.modalPresentationStyle = .popover
            activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            activityViewController.popoverPresentationController?.permittedArrowDirections = .up
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }

}

fileprivate extension ShareViewController {
    // MARK: Setup Methods
    
    func setupShareButton() {
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didPressShare))
        self.navigationItem.rightBarButtonItem = shareItem
    }
}
