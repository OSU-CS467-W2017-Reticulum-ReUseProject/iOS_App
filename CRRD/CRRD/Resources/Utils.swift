//
//  Utils.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import Foundation
import UIKit


//Functions and structs used throughout app
class Utils {
    
    //Colors used throught the app
    struct Colors {
        static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        static let cscGreen = UIColorFromRGB(rgbValue: 0x7C903A)
        static let cscGreenLight = UIColorFromRGB(rgbValue: 0x99B247)
        static let cscGreenDark = UIColorFromRGB(rgbValue: 0x4F5C25)
        static let cscOrange = UIColorFromRGB(rgbValue: 0xF89420)
        static let cscBlue = UIColorFromRGB(rgbValue: 0x47A6B2)
        static let cscBlueDark = UIColorFromRGB(rgbValue: 0x415E5E)
    }

    //Sets the appearance of the Navigation bar, status bar, drop down menu, and table view
    static func appTheme() {
        
        //Set status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Navigation bar appearance
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Utils.Colors.cscGreenDark
        navigationBar.tintColor = UIColor.white
        
        //Table view appearance
        let tableView = UITableView.appearance()
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Drop down menu appearance
        let dropDownMenu = FTConfiguration.shared
        dropDownMenu.menuRowHeight = 35
        dropDownMenu.menuWidth = 150
        dropDownMenu.textColor = UIColor.white
        dropDownMenu.backgoundTintColor = Colors.cscGreenDark
        dropDownMenu.textAlignment = .right
        dropDownMenu.menuSeparatorColor = Colors.cscGreenDark
    }
    
    //Gets all the strings un the Strings.plist file
    static func getStrings() -> [String: Any] {
        
        if let path = Bundle.main.path(forResource: "Strings", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict
        }
        return [:]
    }
}





