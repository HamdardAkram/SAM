//
//  ProductDetailAdapter.swift
//  SamApp
//
//  Created by Muhammad Akram on 04/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

enum ProductSections: Int {
    case shopthelook = 0, session = 1, notes = 2
}

protocol ProductDetailAdapterDelegate: AnyObject {
    
    func showPhotoGallery()
    func showProductInfo()
    func showCopywrite()
    func didTapOnAddButton(sender: UIButton)
    func didTapOnViewMoreButton(sender: UIButton)
    func didTapOnRow(indexPath: IndexPath)
    func showEditSessionScreen(atIndex: Int)
}

class ProductDetailAdapter: NSObject {

    fileprivate let detailTableView: UITableView
    fileprivate weak var delegate: ProductDetailAdapterDelegate?
    var maxSessionId: Int = 0
    var currentProductIndex: Int = 0 {
        didSet {
            setMaxSessionID()
            self.detailTableView.reloadData()
        }
    }
    
    var productDetail: ProductDetails? {
        didSet {
            setMaxSessionID()
            if let headerView = self.detailTableView.tableHeaderView as? DetailHeaderView {
                
                if self.productDetail?.data.first?.images.count ?? 0 > 0 {
                    if self.productDetail?.data.count ?? 0 > currentProductIndex {
                        headerView.productData = self.productDetail?.data[currentProductIndex]
                    }
                }
            }
            self.detailTableView.reloadData()
        }
    }
    
    var displayViewMoreInSection: [Int: Bool] = [0: false, 1: false, 2: false, 3: false] {
        didSet {
            self.detailTableView.reloadData()
        }
    }
    
    func setMaxSessionID() {
        if self.productDetail?.data.count ?? 0 > currentProductIndex {
            let session = self.productDetail?.data[currentProductIndex].sessions.max { (session1, session2) -> Bool in
                session1.product_session_id < session2.product_session_id
            }
            maxSessionId = session?.product_session_id ?? 0
            
            self.productDetail?.data[currentProductIndex].sessions.sort(by: { (session1, session2) -> Bool in
                session1.product_session_id > session2.product_session_id
            })
        }
    }
    
    init(tableView: UITableView, delegate: ProductDetailAdapterDelegate) {
        self.detailTableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        self.detailTableView.tableHeaderView = getHeaderView()
        self.detailTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))

        self.detailTableView.isEditing = true
        self.detailTableView.allowsSelectionDuringEditing = true

        self.registerCells()
        self.registerHeaderAndFooter()
    }
    
    func getHeaderView() -> UIView {
        let headerView = Bundle.main.loadNibNamed("DetailHeaderView", owner: self, options: nil)?.first
        guard let view = headerView as? DetailHeaderView else {
            return UIView()
        }
        view.headerDelegate = self
         
        //view.contentView.backgroundColor = UIColor.black
        return view
    }
    
    func getFooterView() -> UIView {
        let footerView = Bundle.main.loadNibNamed("DetailFooterView", owner: self, options: nil)?.first
        guard let view = footerView as? DetailFooterView else {
            return UIView()
        }
        view.footerDelegate = self
        view.contentView.backgroundColor = UIColor.black
        return view
    }
}

fileprivate extension ProductDetailAdapter {
    // MARK: Setup Methods
    
    func registerCells() {
        let shopCell = UINib.init(nibName: "ShopTheLookCell", bundle: Bundle.main)
        self.detailTableView.register(shopCell, forCellReuseIdentifier: "ShopTheLookCell")
        
        let sessionCell = UINib.init(nibName: "SessionCell", bundle: Bundle.main)
        self.detailTableView.register(sessionCell, forCellReuseIdentifier: "SessionCell")
        
        let notesCell = UINib.init(nibName: "NotesCell", bundle: Bundle.main)
        self.detailTableView.register(notesCell, forCellReuseIdentifier: "NotesCell")
    }
    
    func registerHeaderAndFooter() {
        let headerNib = UINib.init(nibName: "SectionHeaderView", bundle: Bundle.main)
        self.detailTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        
        let footerNib = UINib.init(nibName: "SectionFooterView", bundle: Bundle.main)
        self.detailTableView.register(footerNib, forHeaderFooterViewReuseIdentifier: "SectionFooterView")
    }
}

extension ProductDetailAdapter: UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.productDetail?.data.count ?? 0 > currentProductIndex {
            guard let product = self.productDetail?.data[currentProductIndex] else {
                return 0
            }
            if let sectionId = ProductSections(rawValue: section) {
                switch sectionId {
                    case .shopthelook:
                        return (product.outfit.count > OUTFIT_COUNT && self.displayViewMoreInSection[section] == false) ? OUTFIT_COUNT : product.outfit.count
                    case .session:
                        return (product.sessions.count > SESSION_COUNT && self.displayViewMoreInSection[section] == false) ? SESSION_COUNT : product.sessions.count
                    case .notes:
                        return (product.notes.count > NOTES_COUNT && self.displayViewMoreInSection[section] == false) ? NOTES_COUNT : product.notes.count
                    }
            }
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sectionId = ProductSections(rawValue: indexPath.section) {
            guard let product = self.productDetail?.data[currentProductIndex] else {
                return UITableViewCell()
            }
            switch sectionId {
                case .shopthelook:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopTheLookCell.self), for: indexPath) as! ShopTheLookCell
                    cell.delegate = self
                    cell.tag = indexPath.row
                    if product.outfit.count > indexPath.row {
                        cell.setData(outfit: product.outfit[indexPath.row])
                    }
                    return cell
                case .session:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SessionCell.self), for: indexPath) as! SessionCell
                    cell.delegate = self
                    cell.tag = indexPath.row
                    cell.maxSessionId = maxSessionId
                    if product.sessions.count > indexPath.row {
                        cell.setData(session: product.sessions[indexPath.row])
                    }
                    return cell
                case .notes:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotesCell.self), for: indexPath) as! NotesCell
                    cell.tag = indexPath.row
                    cell.delegate = self
                    if product.notes.count > indexPath.row {
                        cell.setData(note: product.notes[indexPath.row])
                    }
                    return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView")
        let header = cell as! SectionHeaderView
        header.setData(section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.section == 0) ? true : false
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionFooterView")
        let footer = cell as! SectionFooterView
        footer.delegate = self
        if self.productDetail?.data.count ?? 0 <= currentProductIndex {
            return footer
        }
        guard let product = self.productDetail?.data[currentProductIndex] else {
            return UITableViewCell()
        }
        footer.setData(section: section, product: product, showViewMore: self.displayViewMoreInSection)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.productDetail?.data.count ?? 0 > currentProductIndex {
            
            guard let product = self.productDetail?.data[currentProductIndex] else {
                return 0
            }
            if let sectionId = ProductSections(rawValue: section) {
                switch sectionId {
                case .shopthelook:
                    return product.outfit.count > 0 ? 90 : 0
                case .session:
                    return product.sessions.count > 0 ? 90 : 0
                case .notes:
                    return 90
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.productDetail?.data.count ?? 0 > currentProductIndex {
        guard let product = self.productDetail?.data[currentProductIndex] else {
            return 0
        }
        if let sectionId = ProductSections(rawValue: section) {
            switch sectionId {
            case .shopthelook:
                return product.outfit.count > 0 ? 70 : 0
            case .session:
                return product.sessions.count > 0 ? 70 : 0
            case .notes:
                return 70
            }
        }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var shopTheLookList = self.productDetail?.data[currentProductIndex].outfit
        let movedObject = shopTheLookList?[sourceIndexPath.row] ?? nil
        shopTheLookList?.remove(at: sourceIndexPath.row)
        if let object = movedObject {
            shopTheLookList?.insert(object, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageView = cell.subviews.first(where: { $0.description.contains("Reorder") })?.subviews.first(where: { $0 is UIImageView }) as? UIImageView

        imageView?.image = UIImage(named: "reorder_icon") // give here your's new image
        imageView?.contentMode = .center
        imageView?.backgroundColor = UIColor.samBlack()
        imageView?.frame.size.width = cell.bounds.height
        imageView?.frame.size.height = cell.bounds.height
         
    }
}

extension ProductDetailAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapOnRow(indexPath: indexPath)
    }
}

extension UITableViewCell {

    var reorderControlImageView: UIImageView? {
        let reorderControl = self.subviews.first { view -> Bool in
            view.classForCoder.description() == "UITableViewCellReorderControl"
        }
        return reorderControl?.subviews.first { view -> Bool in
            view is UIImageView
        } as? UIImageView
    }
}

extension ProductDetailAdapter: DetailHeaderViewDelegate {
    
    func infoRowTapped() {
        self.delegate?.showProductInfo()
    }
    
    func didTapOnItem(indexPath: IndexPath) {
        self.delegate?.showPhotoGallery()
    }
}

extension ProductDetailAdapter: DetailFooterViewDelegate {
    func footerTapped() {
        self.delegate?.showCopywrite()
    }
}

extension ProductDetailAdapter: SectionFooterViewDelegate {
    
    func didTapOnAddButton(sender: UIButton) {
        self.delegate?.didTapOnAddButton(sender: sender)
    }
    
    func didTapOnViewMoreButton(sender: UIButton) {
        self.displayViewMoreInSection[sender.tag] = true
    }
}

extension ProductDetailAdapter: ShopTheLookCellDelegate {
    func deleteButtonClicked(atCell: ShopTheLookCell) {
        if let productDetail = self.productDetail {
            var outfits = productDetail.data[currentProductIndex].outfit
            if outfits.count > atCell.tag {
                outfits.remove(at: atCell.tag)
                productDetail.data[currentProductIndex].outfit = outfits
                self.productDetail = productDetail
            }
        }
    }
}

extension ProductDetailAdapter: NotesCellDelegate {
    func deleteButtonClicked(atCell: NotesCell) {
//        var noteList = self.dataSource["Notes"]
//        noteList?.remove(at: atCell.tag)
//        self.dataSource["Notes"] = noteList
    }
}

extension ProductDetailAdapter: SessionCellDelegate {
    func showEditSession(sender: UIButton) {
        self.delegate?.showEditSessionScreen(atIndex: sender.tag)
    }
}
