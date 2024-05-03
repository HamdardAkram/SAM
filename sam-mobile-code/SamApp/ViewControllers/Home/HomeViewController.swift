//
//  HomeViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 13/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol HomeView: BaseView {

    func moveToSearchScreen()
    func didTapOnRow(indexPath: IndexPath)
}

enum CellType: Int {
    case reports = 0, products = 1, manifests = 2, help = 3, styleguide = 4
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    fileprivate var homeAdapter: HomeAdapter!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("HOME_VC_TITLE", comment: "")
        setupAdapter()
        
//        let button = UIButton(type: .roundedRect)
//          button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//          button.setTitle("Test Crash", for: [])
//          button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//          view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]
          let _ = numbers[1]
      }
}

fileprivate extension HomeViewController {
    func setupAdapter() {
        self.homeAdapter = HomeAdapter(collectionView: self.homeCollectionView, homeView: self)
        self.homeCollectionView.dataSource = self.homeAdapter
    }
}

extension HomeViewController: HomeView {
    func moveToSearchScreen() {
        let searchVC = SearchViewController.instantiate(fromStoryboard: .Search)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func didTapOnRow(indexPath: IndexPath) {
        
        if let cellId = CellType(rawValue: indexPath.row) {
            switch cellId {
                case .reports:
                    let reportSB = UIStoryboard(name: "Report", bundle: Bundle.main)
                    let reportVC = reportSB.instantiateViewController(withIdentifier: "ReportViewController")
                    self.navigationController?.pushViewController(reportVC, animated: true)
                case .products:
                    print("end")
                case .manifests:
                    print("end")
            default:break
//                case .help:
//                    let otherSB = UIStoryboard(name: "Other", bundle: Bundle.main)
//                    let helpVC = otherSB.instantiateViewController(withIdentifier: "HelpAndStyleViewController")
//                    self.navigationController?.pushViewController(helpVC, animated: true)
//                case .styleguide:
//                    let otherSB = UIStoryboard(name: "Other", bundle: Bundle.main)
//                    let helpVC = otherSB.instantiateViewController(withIdentifier: "HelpAndStyleViewController")
//                    self.navigationController?.pushViewController(helpVC, animated: true)
            }
        }
    }
}
