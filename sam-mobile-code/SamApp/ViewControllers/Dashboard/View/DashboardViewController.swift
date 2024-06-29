//
//  DashboardViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 27/06/24.
//  Copyright © 2024 Muhammad Akram. All rights reserved.
//

import UIKit
import Combine

class DashboardViewController: BaseViewController {

    @IBOutlet var dashboardTableView: UITableView!
    
    let viewModel: DashboardViewModel = DashboardViewModel(networkClient: NetworkingClient())
    private var subscriptions: Set<AnyCancellable> = []
    
    private var dashboardData: DashboardData? = nil
    private var selectedMonth: String = ""
    private var selectedEmployee: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Dashboard"
        setupUI()
        setupBindings()
        self.dashboardTableView.showLoading(withMessage: "")
        viewModel.fetchDashboardData()
    }
    
    private func setupUI() {
        dashboardTableView.register(UINib(nibName: "DashboardSummaryCell", bundle: nil), forCellReuseIdentifier: "DashboardSummaryCell")
        dashboardTableView.register(UINib(nibName: "StudioPerformanceCell", bundle: nil), forCellReuseIdentifier: "StudioPerformanceCell")
        dashboardTableView.register(UINib(nibName: "EmployeePerformanceCell", bundle: nil), forCellReuseIdentifier: "EmployeePerformanceCell")
        dashboardTableView.register(UINib(nibName: "StudioStateCell", bundle: nil), forCellReuseIdentifier: "StudioStateCell")
        dashboardTableView.register(UINib(nibName: "SLAStateCell", bundle: nil), forCellReuseIdentifier: "SLAStateCell")
    }
    
    private func setupBindings() {
        viewModel.$dashboardData.sink(receiveValue: { [weak self] data in
            guard let dashboard = data else { return }
            self?.dashboardTableView.hideLoading()
            self?.dashboardData = dashboard
            self?.selectedMonth = dashboard.product_SLA?.keys.first ?? ""
            self?.selectedEmployee = dashboard.employee_performance?.keys.first ?? ""
            self?.dashboardTableView.reloadData()
        }).store(in: &subscriptions)
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardSummaryCell", for: indexPath) as! DashboardSummaryCell
                cell.setData()
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StudioPerformanceCell", for: indexPath) as! StudioPerformanceCell
                if let data = dashboardData {
                    cell.studioPerformanceData = data.studio_performance
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeePerformanceCell", for: indexPath) as! EmployeePerformanceCell
                cell.delegate = self
                cell.dropDownLabel.text = selectedEmployee
                if let data = dashboardData?.employee_performance {
                    cell.employeePerformanceData = data[selectedEmployee]
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StudioStateCell", for: indexPath) as! StudioStateCell
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SLAStateCell", for: indexPath) as! SLAStateCell
                cell.delegate = self
                cell.dropDownLabel.text = selectedMonth
                if let sla = dashboardData?.product_SLA {
                    cell.slaStateData = sla[selectedMonth]
                }
                return cell
            default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(index: indexPath)
    }
}

extension DashboardViewController: EmployeePerformanceCellDelegate {
    func showEmployeePopup() {
        let addressLookupVC = ListModalViewController<String, DashboardViewController>()
        addressLookupVC.delegate = self
        addressLookupVC.popUpType = 0
        addressLookupVC.addressList = dashboardData?.employee_performance?.keys.sorted() ?? []
        addressLookupVC.view.backgroundColor = UIColor.init(white: 0.1, alpha: 0.8)
        self.present(addressLookupVC, animated: true, completion: nil)
    }
}

extension DashboardViewController: SLAStateCellDelegate {
    func showMonthPopup() {
        let addressLookupVC = ListModalViewController<String, DashboardViewController>()
        addressLookupVC.delegate = self
        addressLookupVC.popUpType = 1
        addressLookupVC.addressList = dashboardData?.product_SLA?.keys.sorted() ?? []
        addressLookupVC.view.backgroundColor = UIColor.init(white: 0.1, alpha: 0.8)
        self.present(addressLookupVC, animated: true, completion: nil)
    }
}

extension DashboardViewController: ListModalViewControllerDelegate {
    typealias T = String
    func didSelectRoleAndPhotographyType(value: String, fromViewController vc: UIViewController) {
        if let type = vc as? ListModalViewController<T, DashboardViewController> {
            if type.popUpType == 1 {
                self.selectedMonth = value
                self.dashboardTableView.reloadSections(IndexSet(integer: 4), with: .automatic)
            } else {
                self.selectedEmployee = value
                self.dashboardTableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            }
        }
    }
}
