//
//  RefineSectionHeaderView.swift
//  SamApp
//
//  Created by Akram on 16/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit

protocol RefineSectionHeaderViewDelegate: class {
    
    func toggleSection(header: RefineSectionHeaderView?, section: Int)
}

class RefineSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var stateIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var section: Int = 0
    weak var delegate: RefineSectionHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.titleLabel.setFontMetrics(font: UIFont.thirteenRegular())
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        
        self.containerView.makeRoundCorner(10)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        print("after layout")
//        dump(contentView.constraintsAffectingLayout(for: .vertical))
//    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if newValue.width == 0 { return }
            super.frame = newValue
        }
    }
    
    func setCollapsed(collapsed: Bool) {
        
        if collapsed == true {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.stateIcon.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.stateIcon.transform = self.stateIcon.transform.rotated(by: -CGFloat(Double.pi))
            },completion: nil)
        }
    }
    
    @objc private func didTapHeader() {
        weak var weakSelf = self
        delegate?.toggleSection(header: weakSelf, section: section)
    }
}
