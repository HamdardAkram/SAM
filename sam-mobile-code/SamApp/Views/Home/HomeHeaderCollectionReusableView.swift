//
//  HomeHeaderCollectionReusableView.swift
//  SamApp
//
//  Created by Muhammad Akram on 24/09/19.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import UIKit
import SDWebImage

class HomeHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        searchView.clipsToBounds = true
        searchView.layer.cornerRadius = 22
        SDImageCache.shared.config.shouldCacheImagesInMemory = false
        
        let user = getLoggedInUser()
        headerTitleLabel.text = "Welcome " + (user?.data?.full_name ?? "")
        let imageName = user?.clientLogo ?? ""
        let urlStr = String(format: "%@/%@", "https://studio.sam3.com/assets/uploads", imageName)
        
        logoImageView.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "scan_icon"), options: .refreshCached) { (image, error, type, url) in
            
            self.logoImageView.image = image
        }
    }
    
}
