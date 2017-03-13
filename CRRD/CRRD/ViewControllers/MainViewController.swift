//
//  MainViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var applicationNameLong: UILabel!
    @IBOutlet weak var applicationDescription: UILabel!
    @IBOutlet weak var repairButton: UIButton!
    @IBOutlet weak var reuseButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!
    
    private var categoryList: [CategoryMO] = []
    private var repairItemCategory: CategoryMO! = nil
    
    //Gets the strings stored in the Strings.plist file
    lazy private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidAppear(_ animated: Bool) {
        //UpdateDataModel.updateDataModel()
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
    }
    
    
    /*****************************************************************************/
    //MARK: - Theme
    
    //Adjusts appearance of items in view
    private func viewTheme(){

        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Move the home and drop down menu buttons further to the right
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -6
        self.navigationItem.setRightBarButtonItems([negativeSpacer, dropDownMenuButton, homeButton], animated: false)
        
        //Set view label text
        self.title = strings["ApplicationName"] as! String?
        applicationNameLong.text = strings["ApplicationNameLong"] as! String?
        applicationDescription.text = strings["ApplicationDescription"] as! String?
        
        //Round the corners of the buttons
        repairButton.layer.cornerRadius = 5
        reuseButton.layer.cornerRadius = 5
        recycleButton.layer.cornerRadius = 5
    }
  
    
    /*****************************************************************************/
    //MARK: - Navigation
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIButton) {
        FTPopOverMenu.showForSender(sender: sender, with: ["About","Contact"], done: { (selectedIndex) -> () in
            switch selectedIndex {
            case 0: self.navigationController?.performSegue(withIdentifier: "showAbout", sender: self)
            case 1: self.navigationController?.performSegue(withIdentifier: "showContact", sender: self)
            default: break
            }
        }){}
    }
    
    //Button action that navigates to SubCategoryTableViewController and displays repair subcategories
    @IBAction func repairButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showRepairSubcategory", sender: self)
    }
    
    //Button action that navigates to BusinessListTableViewController and displays recycle businesses
    @IBAction func recycleButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showRecycleBusinessList", sender: self)
    }
    
    //Segue repair button or recycle button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Repair button
        if segue.identifier == "showRepairSubcategory" {
            let subCategoryVC = segue.destination as! SubCategoryTableViewController
            subCategoryVC.category = repairItemCategory
        }
        
        //Recycle button
        if segue.identifier == "showRecycleBusinessList" {
            let businessListVC = segue.destination as! BusinessListTableViewController
            businessListVC.recycleBusinesses = true
        }
    }
    
    //Segue destination for other view controlers to navigate to this view
    //Used by home button on navigation bar
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {}
    
    
    /*****************************************************************************/
    // MARK: - Data source
    
    //Load from core data model
    private func loadData() {
        
        //Load Categories from core data model
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Create Predicate to refine request. In this case, only return "Repair Items" from results
            let predicate = NSPredicate(format: "categoryName == %@", "Repair Items")
            request.predicate = predicate
            
            //Sort results by category name
            let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                categoryList = try context.fetch(request)
                if categoryList.count > 0 {
                    repairItemCategory = categoryList[0]
                }
            } catch {
                let fetchRequestError = ErrorHandler.errorAlertAction(strings["errorTitle"] as! String, strings["errorUnrecognized"] as! String)
                present(fetchRequestError, animated: true, completion:  nil)
            }
            //context.reset() //Free from memory
        }
    }
}

