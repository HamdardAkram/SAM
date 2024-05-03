//
//  SetProductStatusHeaderView.swift
//  SamApp
//
//  Created by Muhammad Akram on 06/11/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import DLRadioButton

protocol SetProductStatusHeaderViewDelegate: class {
    func scanButtonClicked()
    func optionClicked(optionId: Int, comment: String)
}

class SetProductStatusHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var damageButton: DLRadioButton!
    @IBOutlet weak var wrongSizeButton: DLRadioButton!
    @IBOutlet weak var requestToReturnButton: DLRadioButton!
    @IBOutlet weak var heldForModelButton: DLRadioButton!
    @IBOutlet weak var wrongColorButton: DLRadioButton!
    @IBOutlet weak var otherButton: DLRadioButton!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    
    @IBOutlet weak var damageIndicator: UIView!
    @IBOutlet weak var wrongSizeIndicator: UIView!
    @IBOutlet weak var requestIndicator: UIView!
    @IBOutlet weak var wrongColorIndicator: UIView!
    @IBOutlet weak var heldForModelIndicator: UIView!
    @IBOutlet weak var otherIndicator: UIView!
    
    @IBOutlet weak var scanButton: UIButton!
    var selectedButton: DLRadioButton?
    
    
    weak var headerDelegate: SetProductStatusHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.damageIndicator.makeRoundCorner(5)
        self.wrongSizeIndicator.makeRoundCorner(5)
        self.requestIndicator.makeRoundCorner(5)
        self.wrongColorIndicator.makeRoundCorner(5)
        self.heldForModelIndicator.makeRoundCorner(5)
        self.otherIndicator.makeRoundCorner(5)
        
        self.scanButton.makeRoundCorner(22)
    }

    func reasonStrForSelectedOption(option: Int) -> String {
        switch option {
            case 1:
                return DAMAGED_PRODUCTS
            case 2:
                return WRONG_SIZE
            case 3:
                return PRODUCTS_TO_RETURN
            case 4:
                return HELD_FOR_MODEL
            case 5:
                return WRONG_COLOR
            case 6:
                return otherTextField.text ?? ""
            default:
                return ""
            }
    }
    
    @IBAction func optionClicked(_ sender: DLRadioButton) {
        
        self.selectedButton?.isSelected = false
        self.selectedButton?.changeButtonAppearance(color: UIColor.samGray(), alpha: 0.6)
        sender.changeButtonAppearance(color: UIColor.samRed(), alpha: 1.0)
        selectedButton = sender
        sender.isSelected = true
        
        self.headerDelegate?.optionClicked(optionId: sender.tag, comment: reasonStrForSelectedOption(option: sender.tag))
    }
    
    @IBAction func scanButtonClicked(_ sender: UIButton) {
        self.headerDelegate?.scanButtonClicked()
    }
}

extension DLRadioButton {
    func changeButtonAppearance(color: UIColor, alpha: CGFloat) {
        self.iconColor = color
        self.indicatorColor = color
        self.alpha = alpha
    }
}

extension SetProductStatusHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
