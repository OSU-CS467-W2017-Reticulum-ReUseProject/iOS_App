//
//  Link.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import UIKit

//Model for link
class Link: NSObject {
    
    var name: String! = nil
    var uri: String! = nil
    
    override init(){}
    
    init(name: String, uri: String) {
        self.name = name
        self.uri = uri
    }
    
    //Initialize with another link
    init(link: Link) {
        self.name = link.name
        self.uri = link.uri
    }
}
