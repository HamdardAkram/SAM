//
//  AddNotesViewController.swift
//  SamApp
//
//  Created by Muhammad Akram on 07/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol AddNotesView: BaseProtocol {
    func newNoteCreated(productInfo: ProductDetails, message: String, code: Int)
    func fetchExistingNotes(productInfo: ProductDetails, message: String, code: Int)
}

class AddNotesViewController: BaseModalViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var noteButton: UIButton!
    
    var productInfo: ProductData?
    
    fileprivate var notesPresenter: AddNotesPresenterProtocol!
    
    weak var delegate:AddSessionViewDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.makeRoundCorner(24)
        self.noteButton.makeRoundCorner(16)
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewOnTap(tapGesture:)))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        setupPresenter()
        let user = getLoggedInUser()
        if let packshotId = self.productInfo?._id {
            let dict: [String: Any] = ["packshot_id": packshotId, "client_name": user?.client_name ?? "", "product_attributes": ["notes"]]
            self.notesPresenter.getExistingNote(productInfo: dict)
        }
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    @IBAction func addNoteButtonClicked(_ sender: UIButton) {
        if textView.text.isEmpty == true {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            let alert = UIAlertController(title: "Message", message: "Text field is empty.", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var noteList =  [[String: Any]]()
        
        if let product = productInfo {
            let jsonEncoder = JSONEncoder()
            for note in product.notes {
                do {
                    let jsonData = try jsonEncoder.encode(note)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    print("JSON String : " + jsonString!)
                    guard let noteDict = convertToDictionary(text: jsonString!) else {
                        return
                    }
                    noteList.append(noteDict)
                }
                catch {

                }
            }
        }
        let newDict: [String: Any] = ["comment": textView.text!, "comment_by": getLoggedInUser()?.data?.full_name ?? "Unknown", "comment_date": Date().timeIntervalSince1970]
        noteList.append(newDict)
        
        let user = getLoggedInUser()
        if let packshotId = self.productInfo?._id {
            let dict: [String: Any] = ["packshot_id": packshotId, "client_name": user?.client_name ?? "", "notes": noteList]
            self.notesPresenter.addNewNote(productInfo: dict)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.view)
        if self.containerView.frame.contains(touchPoint) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func dismissViewOnTap(tapGesture: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension AddNotesViewController {
    
    func setupPresenter() {
        let interactor = AddNotesInteractor(networkClient: NetworkingClient())
        self.notesPresenter = AddNotesPresenter(notesInteractor: interactor, notesView: self)
    }
}

extension AddNotesViewController: AddNotesView {
    func newNoteCreated(productInfo: ProductDetails, message: String, code: Int) {
        self.delegate?.updateProductPage()
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchExistingNotes(productInfo: ProductDetails, message: String, code: Int) {
        self.productInfo = productInfo.data.first
    }
    
    func showActivityIndicator(withMessage message: String) {
        self.showLoading(withMessage: message)
    }
    
    func hideActivityIndicator() {
        self.hideLoading()
    }
}
