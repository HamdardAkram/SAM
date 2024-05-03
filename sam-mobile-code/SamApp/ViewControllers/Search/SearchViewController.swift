//
//  SearchViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 25/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func readBarcode(barcode: String)
}

class SearchViewController: BaseViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    var selectedTextField: UITextField?
    var sectionItems = [RefineSection]()
    var barcodeFieldIndex: Int = 0
    
    fileprivate var initialContentInset: UIEdgeInsets?
    fileprivate var searchPresenter: SearchResultPresenterProtocol!
    
    fileprivate var searchAdapter: SearchAdapter!
    fileprivate var pickerAdapter: PickerViewAdapter!
    
    fileprivate var pickerView: ToolbarPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchButton.clipsToBounds = true
        self.searchButton.layer.cornerRadius = 22.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

        if self.initialContentInset == nil {
            self.initialContentInset = self.searchTableView.contentInset
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nibName)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nibName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pickerView = ToolbarPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260))
        setupAdapter()
        setupPresenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchAdapter = nil
        self.pickerAdapter = nil
        self.searchPresenter = nil
        self.selectedTextField = nil
        self.pickerAdapter = nil
    }
    
    @IBAction func onSearchButtonClick(_ sender: Any) {
        
        let dict = LocalHelper.shared.searchParameterDict(sectionItems: self.searchAdapter.sectionItems, startOffset: 0, limit: 15)
        self.searchPresenter.searchProduct(productInfo: dict as [String : Any], withOffset: 0, count: 15)
        
    }
}

fileprivate extension SearchViewController {
    func setupAdapter() {
        self.searchAdapter = SearchAdapter(tableView: self.searchTableView, delegate: self)
        self.searchTableView.dataSource = self.searchAdapter
        if self.sectionItems.count > 0 {
            self.searchAdapter.sectionItems = self.sectionItems
        }
        self.pickerAdapter = PickerViewAdapter(pickerView: self.pickerView!, delegate: self)
        self.pickerView?.dataSource = self.pickerAdapter
        
        self.pickerAdapter.itemList = [SELECT_DATE_TYPE, CREATE_DATE, TEXT_ENRICHMENT_DATE, REQUEST_DATE, PICK_DATE, SCAN_IN_DATE, SHOT_STILL_DATE, SHOT_MODEL_DATE, SHOT_MANNAQUIN_DATE, SCAN_OUT_DATE, COPYWRITE_DATE, UPLOAD_DATE, VIDEO_SHOT_DATE, MODEL_UPLOAD_DATE, MANNAQUIN_UPLOAD_DATE, STILL_UPLOAD_DATE, DISPATCHED_DATE, STYLE_SHOOT_DATE, PHOTO_DATE, DELIVERY_DATE, COLLECTION_DATE]
    }
    
    func setupPresenter() {
        let interactor = SearchResultInteractor(networkClient: NetworkingClient())
        self.searchPresenter = SearchResultPresenter(searchInteractor: interactor, searchResultView: self, totalProducts: 0)
    }
}



extension SearchViewController: SearchAdapterDelegate {
    
    func textFieldBeginEditing(textField: CustomTextField) {
        switch textField.tag {
        case 4:
            self.selectedTextField = textField
        default:
            print("end")
        }
    }
    
    func textFieldEndEditing(textField: CustomTextField) {
    }
    
    func getPickerView() -> ToolbarPickerView {
        return self.pickerView!
    }
    
    func scanButtonClicked(index: Int) {
        self.sectionItems = self.searchAdapter.sectionItems
        self.barcodeFieldIndex = index
        let scanVC = BarcodeReaderViewController()
        scanVC.barcodeOption = .search
        scanVC.searchDelegate = self
        let navC = UINavigationController(rootViewController: scanVC)
        navC.navigationBar.tintColor = UIColor.white
        navC.navigationBar.barStyle = .black
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true, completion: nil)
    }
}

extension SearchViewController: PickerViewAdapterDelegate {
    func didTapOnRow(index: Int) {
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
        if self.selectedTextField?.text == SELECT_DATE_TYPE {
            self.searchAdapter.resetDateFields()
            self.selectedTextField?.resignFirstResponder()
        }
    }
    
    func didTapDone(index: Int) {
        self.selectedTextField?.text = self.pickerAdapter.itemList[index]
        self.selectedTextField?.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.selectedTextField?.resignFirstResponder()
        self.selectedTextField?.text = nil
    }
}

extension SearchViewController: SearchResultView {
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
    
    func hideLoadMoreIndicator() {
    }
    
    func productDetailStatus(productDetail: ProductDetails, message: String, code: Int) {
        DispatchQueue.main.async {
            self.sectionItems = self.searchAdapter.sectionItems
            if productDetail.data.count == 1 {
                let productDetailVC = ProductDetailViewController.instantiate(fromStoryboard: .Product)
                productDetailVC.productsFromSearchResult = productDetail
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
            else {
                let searchResultVC = SearchResultViewController.instantiate(fromStoryboard: .Search)
                searchResultVC.sectionItems = self.searchAdapter.sectionItems
                searchResultVC.startOffset = searchResultVC.startOffset + searchResultVC.limit
                searchResultVC.productDetail = productDetail
                searchResultVC.totalProducts = productDetail.totalRecords
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
        }
    }
}

extension SearchViewController: DateCellDelegate {
    func checkDates(message: String) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    func readBarcode(barcode: String) {
        let sectionItem = self.sectionItems[0]
        let item = sectionItem.items[self.barcodeFieldIndex]
        item.itemValue = barcode
    }
}

extension SearchViewController {
    // MARK: Keyboard Notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.setContentInset(forKeyboardHeight: keyboardFrame.size.height)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.searchTableView.contentInset = self.initialContentInset ?? UIEdgeInsets.zero
    }
    
    fileprivate func setContentInset(forKeyboardHeight keyboardHeight: CGFloat) {
        var adjustedKeyboardHeight: CGFloat = keyboardHeight
        if #available(iOS 11.0, *) {
            adjustedKeyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom
        }
        
        var contentInset = self.searchTableView.contentInset
        contentInset.bottom = adjustedKeyboardHeight
        self.searchTableView.contentInset = contentInset
        self.searchTableView.scrollIndicatorInsets = contentInset
    }
}
