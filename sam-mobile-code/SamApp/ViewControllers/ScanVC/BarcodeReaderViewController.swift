//
//  BarcodeViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/10/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import AVFoundation

protocol BaseProtocol: BaseView {
    func showActivityIndicator(withMessage message: String)
    func hideActivityIndicator()
}

protocol BarcodeScanView: BaseProtocol {
    func productDetailStatus(productDetail: ProductDetails, message: String, isValid: Bool)
    func scanWorkFlowStatus(productDetail: ProductDetails, message: String, code: Int)
    func scanWrongProduct(productDetail: ProductDetails, message: String, code: Int)
}

protocol ScanView: BaseProtocol {
    
    func scanProductStatus(message: String, code: Int)
}

protocol BarcodeReaderViewControllerDelegate: class {
    func wrongProductSet(product: ProductDetails)
}

class BarcodeReaderViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var barcodeOption: BarcodeOptions = .scanProductIn

    weak var delegate: BarcodeReaderViewControllerDelegate?
    weak var outfitDelegate: ProductDetailViewControllerDelegate?
    weak var searchDelegate: SearchViewControllerDelegate?
    
    var textField: UITextField!
    
    var scannedBarcode: String = ""
    var wrongProductReason: String = ""
    var productsToBeScanned: [ProductDetails] = []
    var closeButtonCliced: Bool = false
    
    var videoCaptureDevice: AVCaptureDevice!
    
    let serialQueue = DispatchQueue(label: "serial")
    
    fileprivate var scanPresenter: ScanPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var titleStr = ""
        switch self.barcodeOption {
            case .scanProductIn:
                titleStr = "Scan Product In"
            case .scanProductOut:
                titleStr = "Scan Product Out"
            case .scanProductToSetStatus:
                titleStr = "Scan To Set Status"
            case .nonProductionScanIn:
                titleStr = "Non Production Scan In"
            case .wardrobeScanIn:
                titleStr = "Wardrobe Scan In"
            case .wardrobeScanOut:
                titleStr = "Wardrobe Scan Out"
            case .outfit:
                titleStr = "Outfit"
            case .search:
                titleStr = "Scan Barcode"
            case .workFlowScan:
                titleStr = "Workflow Scan"
        }
        self.navigationItem.title = titleStr//NSLocalizedString("BARCODE", comment: "")
        
        initializeView()
        
        view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPresenter()
        
        initializeCaptureSession()
        
        if (captureSession?.isRunning == false) {
            startCameraToScan()
            do {
                try videoCaptureDevice.setLight(on: true)
            }
            catch {
                
            }
        }
        if barcodeOption == .workFlowScan {
            if let preferences = UserDefaults.standard.value(forKey: USER_PREFERENCES) {
                print(preferences)
            }
            else {
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                    let vcs = self.navigationController?.tabBarController?.viewControllers
                    guard let navC = vcs?.last as? UINavigationController else {
                        return
                    }
                    
                    if let profileVC = navC.topViewController as? ProfileViewController {
                        
                        profileVC.comingFromScanProduct = true
                        self.navigationController?.tabBarController?.selectedIndex = 3
                    }
                }
                
                let alert = UIAlertController(title: "Message", message: "Your preferences are not set. Plese set your preferences first", preferredStyle: .alert)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanPresenter = nil
        DispatchQueue.global().async {
            if (self.captureSession?.isRunning == true) {
                self.captureSession.stopRunning()
            }
        }
        
    }
    
    @objc func cancelClicked() {
        textField.text = ""
    }
    
    func initializeView() {
        
        let inputFieldView = UIView()
        inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        inputFieldView.makeBorder(1.0, color: UIColor.colorFromHexWithAlpha(rgbValue: 0xffffff, alpha: 0.3))
        inputFieldView.makeRoundCorner(3.0)
        inputFieldView.isUserInteractionEnabled = true
        inputFieldView.backgroundColor = .black
        
        textField = UITextField(frame: CGRect(x: 10, y: 5, width: view.frame.width - 70, height: 30))
        textField.textColor = .white
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "Enter barcode here",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.samGray()])
        textField.font = UIFont.tofinoRegularFifteen()
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: view.frame.width - 70, y: 5, width: 30, height: 30)
        cancelButton.setImage(UIImage(named: "close_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.imageView?.tintColor = UIColor.samGray()
        cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        inputFieldView.addSubview(cancelButton)
        
        inputFieldView.addSubview(textField)
        view.addSubview(inputFieldView)
        let topPos: CGFloat = (barcodeOption == .workFlowScan) ? 10 : 95
        NSLayoutConstraint.activate([(inputFieldView).topAnchor.constraint(equalTo: view.topAnchor, constant:  CGFloat(topPos)), (inputFieldView).leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),(inputFieldView).trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), (inputFieldView).heightAnchor.constraint(equalToConstant: 40)])
        
        if barcodeOption != .workFlowScan {
            let barButton = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(onCloseButtonClick))
            barButton.tintColor = UIColor.samRed()
            self.navigationItem.leftBarButtonItem = barButton
            
            let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonCliced))
            backButton.tintColor = UIColor.samRed()
            self.navigationItem.backBarButtonItem = backButton
            
            let viewScanButton = UIButton(type: .custom)
            viewScanButton.translatesAutoresizingMaskIntoConstraints = false
            viewScanButton.setTitle("View Scanned", for: .normal)
            viewScanButton.titleLabel?.textAlignment = .right
            viewScanButton.titleLabel?.font = UIFont.tofinoRegularFifteen()
            viewScanButton.setTitleColor(UIColor.samRed(), for: .normal)
            viewScanButton.addTarget(self, action: #selector(onViewScanButtonClick), for: .touchUpInside)
            view.addSubview(viewScanButton)
            
            NSLayoutConstraint.activate([(viewScanButton).trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            (viewScanButton).bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
            (viewScanButton).widthAnchor.constraint(equalToConstant: 120),
            (viewScanButton).heightAnchor.constraint(equalToConstant: 21)])
        }
        let startScanButton = UIButton(type: .custom)
        startScanButton.translatesAutoresizingMaskIntoConstraints = false
        startScanButton.setImage(UIImage(named: "start_scan_icon"), for: .normal)
        startScanButton.addTarget(self, action: #selector(onStartScanButtonClick), for: .touchUpInside)
        view.addSubview(startScanButton)
        
        let bottomConstraint = (barcodeOption == .workFlowScan) ? -20 : -84
        NSLayoutConstraint.activate([(startScanButton).centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     (startScanButton).bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(bottomConstraint)),
                                     (startScanButton).widthAnchor.constraint(equalToConstant: 74),
                                     (startScanButton).heightAnchor.constraint(equalToConstant: 74)])
    }
    
    func initializeCaptureSession() {
        if barcodeOption == .workFlowScan && UserDefaults.standard.value(forKey: USER_PREFERENCES) == nil {
            return
        }
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        self.videoCaptureDevice = videoCaptureDevice
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes// [.ean8, .ean13, .pdf417, .qr, .e]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let yPos: CGFloat = (barcodeOption == .workFlowScan) ? 60 : 144
        previewLayer.frame = CGRect(x: 0, y: yPos, width: view.frame.width, height: view.frame.height - yPos - 219)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.backgroundColor = UIColor.clear.cgColor
        view.layer.addSublayer(previewLayer)

        startCameraToScan()
        do {
            try videoCaptureDevice.setLight(on: true)
        }
        catch {
            
        }
    }
    
    private func startCameraToScan() {
        serialQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    @objc func backButtonCliced() {
        
    }
    @objc func onCloseButtonClick() {
        closeButtonCliced = true
        if productsToBeScanned.count > 0 {
            let okAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let noAction = UIAlertAction(title: "No", style: .default) { (action) in
                
            }
            let alert = UIAlertController(title: "Message", message: "Do you want to go back without scanning done? All scanned products will be lost", preferredStyle: .alert)
            alert.addAction(okAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onViewScanButtonClick() {
        
        if productsToBeScanned.count == 0 {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            let alert = UIAlertController(title: "Message", message: "There is no product to be scanned", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let scanVC = ScanViewController.instantiate(fromStoryboard: .Scan)
        scanVC.productsToBeScanned = productsToBeScanned
        scanVC.barcodeOption = self.barcodeOption
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @objc func onStartScanButtonClick() {
        startCameraToScan()
        do {
            try videoCaptureDevice.setLight(on: true)
        }
        catch {
            
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    func found(code: String) {
        print(code)
        
        if productsToBeScanned.contains(where: { (product) -> Bool in
            return product.data[0].barcode == code
        }) == true {
            textField.text = ""
            self.showAlertWithMessage(message: "This product is already in scanned list")
            return
        }
        guard let user = getLoggedInUser() else {
            return
        }
        
        var dict: [String: Any] = [:]

        switch barcodeOption {
            case .scanProductIn:
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": user.scanInAttributes]
                self.scanPresenter.getProductDetail(withUserInfo: dict as [String : Any])
            case .scanProductOut:
                let scanInAttributes = user.scanInAttributes + ",wardrobe_product,scan_out_date,copywrite_date,sessions"
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": scanInAttributes]
                self.scanPresenter.getProductDetailForScanOut(withUserInfo: dict as [String : Any])
            case .scanProductToSetStatus:
                scannedBarcode = code
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": user.scanInAttributes]
                self.scanPresenter.getProductDetailToSetStatus(productInfo: dict as [String : Any])
            case .nonProductionScanIn:
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": user.scanInAttributes]
                self.scanPresenter.getProductDetail(withUserInfo: dict as [String : Any])
            case .wardrobeScanIn:
                let scanInAttributes = user.scanInAttributes + ",wardrobe_product,scan_out_date,copywrite_date,sessions"
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": scanInAttributes]
                self.scanPresenter.getProductDetailForWardrobeIn(productInfo: dict as [String : Any])
            case .wardrobeScanOut:
                let scanInAttributes = user.scanInAttributes + ",wardrobe_product,scan_out_date,copywrite_date,sessions"
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": scanInAttributes]
                self.scanPresenter.getProductDetailForWardrobeOut(productInfo: dict as [String : Any])
            case .workFlowScan:
                scannedBarcode = code
                let dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": user.scanInAttributes]
                self.scanPresenter.getProductDetailForWorkFlowScan(withUserInfo: dict as [String : Any])
            case .outfit:
                dict = ["client_name": user.client_name, "search_string": code, "unique_identifier": user.uniqueIdentifier, "scan_in_attributes": user.scanInAttributes]
                self.scanPresenter.getProductDetail(withUserInfo: dict as [String : Any])
            case .search:
                self.searchDelegate?.readBarcode(barcode: code)
                self.dismiss(animated: true, completion: nil)
                print("search")
        }
    }

    func showAlertWithMessage(message: String) {
        DispatchQueue.main.async {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

fileprivate extension BarcodeReaderViewController {
    // MARK: Setup Methods
    
    func setupPresenter() {
        let interactor = ScanInteractor(networkClient: NetworkingClient())
        self.scanPresenter = ScanPresenter(scanInteractor: interactor, scanView: self)
    }
}

extension BarcodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            DispatchQueue.main.async {
                self.captureSession.stopRunning()
                let code = stringValue.trim()
                self.found(code: code)
            }
        }
    }
}

extension BarcodeReaderViewController: BarcodeScanView {
    
    func scanWrongProduct(productDetail: ProductDetails, message: String, code: Int) {
        self.delegate?.wrongProductSet(product: productDetail)
        self.dismiss(animated: true, completion: nil)
    }
    
    func scanWorkFlowStatus(productDetail: ProductDetails, message: String, code: Int) {
        DispatchQueue.main.async {
            if productDetail.statusCode.Value == "200" || productDetail.statusCode.Value == "200.0" {
                let productDetailVC = ProductDetailViewController.instantiate(fromStoryboard: .Product)
                productDetailVC.productId = productDetail.product_id
                self.navigationController?.pushViewController(productDetailVC, animated: true)
                return
            }
            self.showAlertWithMessage(message: productDetail.message)
        }
    }
    
    func productDetailStatus(productDetail: ProductDetails, message: String, isValid: Bool) {
        
        if barcodeOption == .workFlowScan {
            if message.isEmpty {
                var dateType: String = ""
                if let preferences = UserDefaults.standard.value(forKey: USER_PREFERENCES) as? [String: Any] {
                    guard let type = preferences[PHOTOGRAPHY_TYPE] as? String else {
                        return
                    }
                    switch type {
                    case STILLS:
                        dateType = "photo_still_date"
                    case MODEL:
                        dateType = "photo_model_date"
                    case MANNEQUIN:
                        dateType = "photo_mannequin_date"
                    default:
                        print("")
                    }
                    
                    guard let stylist = preferences[STYLIST] as? String else {
                        return
                    }
                    guard let role = preferences[ROLE] as? String else {
                        return
                    }
                                        
                    let user = getLoggedInUser()
                    if user?.isModelManager ?? false {
                        guard let prefsData = preferences[MODEL_DATA] as? Data else {
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let prefs = try decoder.decode(ModelManagerPreferenceData.self, from: prefsData)
                            print(prefs)
                            let dict: [String: Any] = ["date_type": dateType, "client_name": user?.client_name ?? "", "stylist_name": "Akram", "plugin": "0", "barcode": scannedBarcode, "user_name": user?.data?.full_name ?? "", "model_name": prefs.model_name, "set_preference": ["role": role, "photography_type": type, "stylist_on_set": stylist, "is_model_manager": "1", "printer_on_set": "0", "printer_name_set": "", "plugin": "0", "theme_type": "Dark"], "user_rights": "1", "model_data": ["model_id": prefs.model_id, "model_name": prefs.model_name, "model_last_name": prefs.model_last_name, "model_agency": prefs.model_agency, "model_price": prefs.model_price, "model_currency": prefs.model_currency, "model_height": prefs.model_height, "model_bust": prefs.model_bust, "model_waist": prefs.model_waist, "model_hips": prefs.model_hips, "model_shoe": prefs.model_shoe, "model_hair": prefs.model_hair, "model_eyes": prefs.model_eyes, "model_gender": prefs.model_gender, "model_headless": prefs.model_headless, "retention_days": prefs.retention_days, "model_comments": prefs.model_comments, "model_active": prefs.model_active, "createdTime": prefs.createdTime.Value, "modifiedTime": prefs.modifiedTime.Value]]
                            self.scanPresenter.scanProductWorkFlow(productInfo: dict as [String : Any])
                        } catch {
                            let dict: [String: Any] = ["date_type": dateType, "client_name": user?.client_name ?? "", "stylist_name": "Akram", "plugin": "0", "barcode": scannedBarcode, "user_name": user?.data?.full_name ?? "", "set_preference": ["role": role, "photography_type": type, "stylist_on_set": stylist, "is_model_manager": "1", "printer_on_set": "0", "printer_name_set": "", "plugin": "0", "theme_type": "Dark"], "user_rights": "1"]
                            self.scanPresenter.scanProductWorkFlow(productInfo: dict as [String : Any])
                        }
                        
                    }
                    else {
                        guard let model = preferences[MODEL] as? String else {
                            return
                        }
                        let dict: [String: Any] = ["date_type": dateType, "client_name": user?.client_name ?? "", "stylist_name": "Akram", "plugin": "0", "barcode": scannedBarcode, "user_name": user?.data?.full_name ?? "", "set_preference": ["role": role, "photography_type": type, "stylist_on_set": stylist, "is_model_manager": "1", "printer_on_set": "0", "printer_name_set": "", "plugin": "0", "theme_type": "Dark"], "user_rights": "1", "model_name": model]
                        self.scanPresenter.scanProductWorkFlow(productInfo: dict as [String : Any])
                    }
                }
            }
            else {
                showAlertWithMessage(message: message)
            }
        }
        else if barcodeOption == .scanProductToSetStatus {
            if message.isEmpty {
                guard let productId = productDetail.data.first?._id else {
                    return
                }
                let user = getLoggedInUser()
                let dict: [String: Any] = ["client_name": user?.client_name ?? "", "user_name": user?.data?.full_name ?? "", "status": 1, "search_key": "item", "search_type": 1, "comment": wrongProductReason, "productIds": [productId]]
                self.scanPresenter.scanForWrongProduct(productInfo: dict as [String : Any])
            }
            else {
                showAlertWithMessage(message: message)
            }
        }
        else if barcodeOption == .outfit {
            self.outfitDelegate?.productDetailForOutfit(product: productDetail)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            textField.text = ""
            if isValid {
                self.productsToBeScanned.append(productDetail)
            }
            self.showAlertWithMessage(message: message)
        }
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
}

extension AVCaptureDevice {
    func setLight(on: Bool) throws {
        try self.lockForConfiguration()
        if on {
            if self.isFlashAvailable {
                try self.setTorchModeOn(level: 1)
            }
        }
        else {
            self.torchMode = .off
        }
        self.unlockForConfiguration()
    }
}

extension BarcodeReaderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.captureSession.stopRunning()
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if closeButtonCliced == true {
            return
        }
        startCameraToScan()
        
        do {
            try videoCaptureDevice.setLight(on: true)
        }
        catch {
            
        }
        
        if let code = textField.text {
            if code.count > 0 {
                self.found(code: code)
            }
        }
    }
}
