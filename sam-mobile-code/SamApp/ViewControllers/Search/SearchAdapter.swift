//
//  SearchAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 25/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SearchAdapterDelegate: class {
    func getPickerView() -> ToolbarPickerView
    func textFieldEndEditing(textField: CustomTextField)
    func textFieldBeginEditing(textField: CustomTextField)
    func scanButtonClicked(index: Int)
}

enum SearchSection: Int {
    case criteria1
    case criteria2
    case criteria3
    
    init?(indexPath: NSIndexPath) {
        self.init(rawValue: indexPath.section)
    }
}

class SearchAdapter: NSObject {
    
    fileprivate let searchTableView: UITableView
    fileprivate weak var delegate: SearchAdapterDelegate?
    
    var sectionItems = [RefineSection]()
    var section1Criteria: [SectionItem] = []
    var previouslyExpandedSection: Int = -1
        
    init(tableView: UITableView, delegate: SearchAdapterDelegate) {
        self.searchTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        let user = getLoggedInUser()
        guard let attributes = user?.productAttributes else {
            return
        }
        for attribute in attributes {
            let str = attribute.replacingOccurrences(of: "_", with: " ")
            let section = SectionItem(itemName: str.capitalized, itemValue: "")
            section1Criteria.append(section)
        }
                
        let searchList2 = [SectionItem(itemName: "All product code", itemValue: ""), SectionItem(itemName: "Selling price", itemValue: ""), SectionItem(itemName: "Special delivery", itemValue: ""), SectionItem(itemName: "Season", itemValue: ""), SectionItem(itemName: "Select Date Type", itemValue: ""), SectionItem(itemName: "From Date", itemValue: ""), SectionItem(itemName: "Scanner", itemValue: ""), SectionItem(itemName: "Copywriter", itemValue: "")]
        
        let searchList3 = [SectionItem(itemName: "Still stylist", itemValue: ""), SectionItem(itemName: "Model stylist", itemValue: ""), SectionItem(itemName: "Mannaquin stylist", itemValue: ""), SectionItem(itemName: "Still photographer", itemValue: ""), SectionItem(itemName: "Model photographer", itemValue: ""), SectionItem(itemName: "Mannaquin photographer", itemValue: "")]
        
        let searchType1 = RefineSection(isCollapsible: true, isCollapsed: true, sectionTitle: "Product Attributes", sectionDesc: "Enter search value", items: section1Criteria)
        let searchType2 = RefineSection(isCollapsible: true, isCollapsed: true, sectionTitle: "Workflow dates", sectionDesc: "Enter search value", items: searchList2)
        let searchType3 = RefineSection(isCollapsible: true, isCollapsed: true, sectionTitle: "Photographer / Stylist", sectionDesc: "Enter search value", items: searchList3)
        
        sectionItems.append(searchType1)
        sectionItems.append(searchType2)
        sectionItems.append(searchType3)
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
                
        self.searchTableView.tableHeaderView = getHeaderView()
        self.searchTableView.tableFooterView = UIView()
        
        self.registerCells()
        self.registerSectionHeader()
    }
    
    func getHeaderView() -> UIView {
            
        let view = UIView(frame: CGRect(x: 20, y: 0, width: self.searchTableView.frame.size.width, height: 70))
        view.backgroundColor = UIColor.black
        
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: UIScreen.main.bounds.size.width - 40, height: 45))
        label.font = UIFont.tofinoMediumFifteen()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Find products based on one or multiple search criteria"
        label.textColor = UIColor.white
        label.textAlignment = .center
        view.addSubview(label)
        
        return view
    }
    
    func reloadSections(section: Int) {
        self.searchTableView.beginUpdates()
        self.searchTableView.reloadSections([section], with: .fade)
        self.searchTableView.endUpdates()
    }
    
    func resetDateFields() {
        for section in sectionItems {
            section.fromDate = nil
            section.toDate = nil
        }
        self.searchTableView.reloadData()
    }
}

fileprivate extension SearchAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let addressNib = UINib.init(nibName: "RefineTableViewCell", bundle: Bundle.main)
        self.searchTableView.register(addressNib, forCellReuseIdentifier: "RefineTableViewCell")
        
        let dateNib = UINib.init(nibName: "DateCell", bundle: Bundle.main)
        self.searchTableView.register(dateNib, forCellReuseIdentifier: "DateCell")
    }
    
    func registerSectionHeader() {
        let sectionNib = UINib.init(nibName: "RefineSectionHeaderView", bundle: Bundle.main)
        self.searchTableView.register(sectionNib, forHeaderFooterViewReuseIdentifier: "RefineSectionHeaderView")
    }
}

extension SearchAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionItems[section]
        if section.isCollapsible && section.isCollapsed {
            return 0
        }
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DateCell.self), for: indexPath) as! DateCell
            cell.delegate = self
            cell.dateDelegate = self.delegate as? DateCellDelegate
            cell.tag = indexPath.row
            let section = sectionItems[indexPath.section]
            cell.setData(sectionItem: section, indexPath: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RefineTableViewCell.self), for: indexPath) as! RefineTableViewCell
            cell.delegate = self
            cell.tag = indexPath.row
            let section = sectionItems[indexPath.section]
            cell.setData(sectionItem: section, indexPath: indexPath)
            
            return cell
        }
    }
}

extension SearchAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RefineSectionHeaderView.self)) as? RefineSectionHeaderView {
            headerView.contentView.backgroundColor = UIColor.black
            let item = sectionItems[section]
            if item.sectionTitle.isEmpty == false {
                headerView.titleLabel.text = item.sectionTitle
                headerView.descLabel.text = item.sectionDesc
            }
            headerView.setCollapsed(collapsed: item.isCollapsed)
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        else {
            return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 70))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SearchAdapter: RefineSectionHeaderViewDelegate {
    
    func expandCollpaseSection(header: RefineSectionHeaderView?, section: Int) {
        let item = sectionItems[section]
        if item.isCollapsible {
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header?.setCollapsed(collapsed: collapsed)
            
            reloadSections(section: section)
        }
    }
    
    func toggleSection(header: RefineSectionHeaderView?, section: Int) {
        
        if self.previouslyExpandedSection >= 0 && self.previouslyExpandedSection != section {
            //collapse previous section
            expandCollpaseSection(header: header, section: self.previouslyExpandedSection)
            self.previouslyExpandedSection = section
            expandCollpaseSection(header: header, section: section)
        }
        else {
            if self.previouslyExpandedSection == section {
                self.previouslyExpandedSection = -1
            }
            else {
                self.previouslyExpandedSection = section
            }
            expandCollpaseSection(header: header, section: section)
        }
    }
}

//extension SearchAdapter: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

extension SearchAdapter: RefineTableViewCellDelegate {
    
    func textFieldEndEditing(textField: CustomTextField) {
        guard let section = textField.indexPath?.section else {
            return
        }
        let sectionItem = self.sectionItems[section]
        if let row = textField.indexPath?.row {
            let item = sectionItem.items[row]
            item.itemValue = textField.text ?? ""
        }
        
        self.delegate?.textFieldEndEditing(textField: textField)
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.delegate?.getPickerView() ?? ToolbarPickerView()
    }
    
    func textFieldBeginEditing(textField: CustomTextField) {
        self.delegate?.textFieldBeginEditing(textField: textField)
    }
    
    func scanButtonClicked(index: Int) {
        self.delegate?.scanButtonClicked(index: index)
    }
}
