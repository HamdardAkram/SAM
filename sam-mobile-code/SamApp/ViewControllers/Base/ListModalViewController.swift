//
//  ListModalViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 11/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol ListModalViewControllerDelegate: AnyObject {
    associatedtype T
    
    func didSelectRoleAndPhotographyType(value: T, fromViewController vc: UIViewController)
    
}

class ListModalViewController<T: CustomStringConvertible, D: ListModalViewControllerDelegate>: BaseModalViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate where D.T == T {

    fileprivate var tableView: UITableView!
    var currentSelectedIndex: Int = 0
    var popUpType: Int = 0
    
    weak var delegate: D?
    
    var addressList: [T] = [T]() {
        didSet {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.registerCells()
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewOnTap(tapGesture:)))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.view)
        if self.tableView.frame.contains(touchPoint) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func dismissViewOnTap(tapGesture: UIGestureRecognizer) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LabelTableViewCell.self), for: indexPath) as! LabelTableViewCell
        
        cell.nameLabel.text = "\(addressList[indexPath.row])"
        
        //cell.nameLabel.textColor = UIColor.dynamicWhite()
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentSelectedIndex = indexPath.row
        self.delegate?.didSelectRoleAndPhotographyType(value: self.addressList[indexPath.row], fromViewController: self)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

fileprivate extension ListModalViewController {
    // MARK: Setup Methods
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        let height:CGFloat = CGFloat(self.addressList.count * 44)
        NSLayoutConstraint.activate([
            self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.tableView.widthAnchor.constraint(equalToConstant: 260),
            self.tableView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func registerCells() {
        let addressNib = UINib.init(nibName: String(describing: LabelTableViewCell.self), bundle: Bundle.main)
        self.tableView.register(addressNib, forCellReuseIdentifier: String(describing: LabelTableViewCell.self))
    }
}



