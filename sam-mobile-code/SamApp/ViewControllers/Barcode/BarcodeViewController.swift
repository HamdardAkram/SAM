//
//  BarcodeViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 14/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

enum BarcodeOptions: Int {
    case scanProductIn = 0, scanProductOut = 1, scanProductToSetStatus = 2, nonProductionScanIn = 3, wardrobeScanIn = 4, wardrobeScanOut = 5, workFlowScan = 6, outfit = 7, search = 8
}

protocol BarcodeView: BaseView {

    func didTapOnRow(indexPath: IndexPath)
}

class BarcodeViewController: BaseViewController {

    @IBOutlet weak var barcodeTableView: UITableView!
    
    fileprivate var barcodeAdapter: BarcodeAdapter!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("BARCODE", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdapter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.barcodeAdapter = nil
    }
    
    @IBAction func unwindToBarcode(segue: UIStoryboardSegue) {
        
    }
}

fileprivate extension BarcodeViewController {
    func setupAdapter() {
        self.barcodeAdapter = BarcodeAdapter(tableView: self.barcodeTableView, barcodeView: self)
        self.barcodeTableView.dataSource = self.barcodeAdapter
    }
}

extension BarcodeViewController: BarcodeView {
    
    func didTapOnRow(indexPath: IndexPath) {
        
        if let cellId = BarcodeOptions(rawValue: indexPath.row) {
            if cellId == .scanProductToSetStatus {
                let statusVC = SetProductStatusViewController.instantiate(fromStoryboard: .Scan)
                self.navigationController?.pushViewController(statusVC, animated: true)
            }
            else {
                let scanVC = BarcodeReaderViewController()
                scanVC.barcodeOption = cellId
                let navC = UINavigationController(rootViewController: scanVC)
                navC.navigationBar.tintColor = UIColor.white
                navC.navigationBar.barStyle = .black
                self.barcodeTableView.deselectRow(at: indexPath, animated: false)
                navC.modalPresentationStyle = .fullScreen
                self.present(navC, animated: true, completion: nil)
            }
        }
    }
}
