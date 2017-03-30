//
//  Category.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import UIKit

//Model for category
class Category: NSObject {
    
    var name: String! = nil
    var subcategoryList: [String] = []

    override init(){}
    
    init(_ name: String,_ subcategoryList: [String]) {
        self.name = name
        self.subcategoryList = subcategoryList
    }
    
    //Initialize with another category object
    init(category: Category) {
        self.name = category.name
        for item in category.subcategoryList {
            let tmpSubCategory = item
            self.subcategoryList.append(tmpSubCategory)
        }
    }
}
