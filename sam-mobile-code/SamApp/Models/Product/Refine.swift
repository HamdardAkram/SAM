//
//  Refine.swift
//  SamApp
//
//  Created by Akram on 16/02/18.
//  Copyright © 2019 Muhammad Akram. All rights reserved.
//

import Foundation

class RefineSection {
    
    var isCollapsible: Bool
    var isCollapsed: Bool
    
    var sectionTitle: String
    var sectionDesc: String
    
    var items: [SectionItem]
    var fromDate: Date?
    var toDate: Date?
    
    init(isCollapsible: Bool, isCollapsed: Bool, sectionTitle: String, sectionDesc: String, items: [SectionItem]) {
        
        self.isCollapsed = isCollapsed
        self.isCollapsible = isCollapsible
        self.sectionTitle = sectionTitle
        self.sectionDesc = sectionDesc
        self.items = items
    }
}

class SectionItem {
    
    var itemName: String
    var itemValue: String
    
    init(itemName: String, itemValue: String) {
        self.itemName = itemName
        self.itemValue = itemValue
    }
}
