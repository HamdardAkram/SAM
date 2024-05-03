//
//  ProfileViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

enum ProfileInfoCell: Int {
    case accountDetail = 0, preferences = 1, manageModel = 2, logout = 3
}

protocol ProfileView: BaseView {

    func didTapOnRow(indexPath: IndexPath)
}

class ProfileViewController: BaseViewController {

    @IBOutlet weak var profileTableView: UITableView!
    
    fileprivate var profileAdapter: ProfileAdapter!
    
    var comingFromScanProduct: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("PROFILE", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdapter()
        if comingFromScanProduct == true {
            let preferencesVC = PreferencesViewController.instantiate(fromStoryboard: .Profile)
            preferencesVC.comingFromScanProduct = true
            self.navigationController?.pushViewController(preferencesVC, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        comingFromScanProduct = false
        self.profileAdapter = nil
    }
    
    func logoutButtonClicked() {
            DispatchQueue.main.async {
                self.showOkCancelAlertWithAction(NSLocalizedString("LOGOUT_MESSAGE", comment: "")) { (isOk) in
                if isOk {
                    UserDefaults.standard.removeObject(forKey: USER_PREFERENCES)
                    UserDefaults.standard.removeObject(forKey: LOGGEDIN_USER)
                    UserDefaults.standard.synchronize()
                    self.tabBarController?.navigationController?.popToRootViewController(animated: true)
                    let vc = SignInViewController.instantiate(fromStoryboard: .Main)
                    let viewController = UINavigationController(rootViewController: vc)
                    
                    if #available(iOS 13.0, *) {
                        guard let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate else {
                            return
                        }
                        sceneDelegate.window?.rootViewController = viewController
                    }
                    else {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        appDelegate.window?.rootViewController = viewController
                    }
                }
            }
        }
    }
}

fileprivate extension ProfileViewController {
    func setupAdapter() {
        self.profileAdapter = ProfileAdapter(tableView: self.profileTableView, profileView: self)
        self.profileTableView.dataSource = self.profileAdapter
    }
}

extension ProfileViewController: ProfileView {
    
    func didTapOnRow(indexPath: IndexPath) {
        
        if let cellId = ProfileInfoCell(rawValue: indexPath.row) {
            switch cellId {
            case .accountDetail:
                let accountDetailVC = AccountDetailViewController.instantiate(fromStoryboard: .Profile)
                self.navigationController?.pushViewController(accountDetailVC, animated: true)
            case .preferences:
                let preferencesVC = PreferencesViewController.instantiate(fromStoryboard: .Profile)
                self.navigationController?.pushViewController(preferencesVC, animated: true)
            case .manageModel:
                print("coming soon")
            case .logout:
                logoutButtonClicked()
            
            }
        }
        
        
    }
}
