//
//  SetProductStatusViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class SetProductStatusViewController: UIViewController {

    @IBOutlet weak var statusTableView: UITableView!
    fileprivate var statusAdapter: SetProductStatusAdapter!
    
    var wrongProducts: [ProductDetails] = []
    
    var selectedOptionId: Int = 0
    var reasonStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("SCAN_PRODUCT", comment: "")
        
        setupAdapter()
    }

}

fileprivate extension SetProductStatusViewController {
    
    func setupAdapter() {
        self.statusAdapter = SetProductStatusAdapter(tableView: self.statusTableView, delegate: self)
        self.statusTableView.dataSource = self.statusAdapter
    }
}

extension SetProductStatusViewController: SetProductStatusAdapterDelegate {
    
}

extension SetProductStatusViewController: SetProductStatusHeaderViewDelegate {
    
    func scanButtonClicked() {
        if selectedOptionId == 0 {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            let alert = UIAlertController(title: "Message", message: "Plz select product status", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let scanVC = BarcodeReaderViewController()
        scanVC.barcodeOption = .scanProductToSetStatus
        scanVC.wrongProductReason = reasonStr
        scanVC.delegate = self
        
        let navC = UINavigationController(rootViewController: scanVC)
        navC.navigationBar.tintColor = UIColor.white
        navC.navigationBar.barStyle = .black
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true, completion: nil)
    }
    
    func optionClicked(optionId: Int, comment: String) {
        selectedOptionId = optionId
        reasonStr = comment
    }
}

extension SetProductStatusViewController: BarcodeReaderViewControllerDelegate {
    
    func wrongProductSet(product: ProductDetails) {
        self.statusAdapter.dataSource.append(product)
    }
}
