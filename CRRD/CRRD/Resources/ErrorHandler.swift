//
//  ErrorHandler.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
    
    //Configures and Returns an alert menu
    static func errorAlertMenu(_ errorTitle: String,_ errorMessage: String) -> UIAlertController {
        
        //Setup alert menu
        let alertMenu = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .actionSheet)
        let cancelAlertMenu = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertMenu.addAction(cancelAlertMenu)
        
        return alertMenu
    }
    
    //Configures and returns an alert action
    static func errorAlertAction(_ errorTitle: String,_ errorMessage: String) -> UIAlertController {
        
        //Error message when link can't be opened
        let errorAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return errorAlert
    }
}
