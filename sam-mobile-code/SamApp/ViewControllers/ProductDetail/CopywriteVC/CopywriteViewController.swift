//
//  CopywriteViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 26/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

class CopywriteViewController: UIViewController {

    @IBOutlet weak var copywriteTableView: UITableView!
    fileprivate var copywriteAdapter: CopywriteAdapter!
    
    @IBOutlet weak var duplicateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var copywriteObject: ProductCopyright?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("COPYWRITING", comment: "")
        
        self.duplicateButton.makeRoundCorner(22.0)
        self.saveButton.makeRoundCorner(22.0)
        
        setupAdapter()
    }

}

fileprivate extension CopywriteViewController {
    
    func setupAdapter() {
        self.copywriteAdapter = CopywriteAdapter(tableView: self.copywriteTableView, delegate: self)
        self.copywriteTableView.dataSource = self.copywriteAdapter
        self.copywriteAdapter.dataSource = [["title": "Product Description", "value": self.copywriteObject?.product_description ?? ""], ["title": "Inspiration", "value": self.copywriteObject?.inspiration ?? ""], ["title": "Editor's Notes", "value":  self.copywriteObject?.editors_note ?? ""], ["title": "Bullet 1", "value": self.copywriteObject?.bullet_1 ?? ""], ["title": "Bullet 2", "value": self.copywriteObject?.bullet_2 ?? ""], ["title": "Bullet 3", "value": self.copywriteObject?.bullet_3 ?? ""], ["title": "Bullet 4", "value": self.copywriteObject?.bullet_4 ?? ""], ["title": "Bullet 5", "value": self.copywriteObject?.bullet_5 ?? ""], ["title": "Bullet 6", "value": self.copywriteObject?.bullet_6 ?? ""], ["title": "Bullet 7", "value": self.copywriteObject?.bullet_7 ?? ""], ["title": "Bullet 8", "value":  self.copywriteObject?.bullet_8 ?? ""], ["title": "Bullet 9", "value": self.copywriteObject?.bullet_9 ?? ""], ["title": "Bullet 10", "value": self.copywriteObject?.bullet_10 ?? ""], ["title": "Bullet 11", "value": self.copywriteObject?.bullet_11 ?? ""], ["title": "QC Approved", "value": self.copywriteObject?.qc_approved.Value ?? ""]]
    }
}

extension CopywriteViewController: CopywriteAdapterDelegate {
    
}
