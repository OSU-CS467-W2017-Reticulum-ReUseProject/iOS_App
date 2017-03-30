//
//  SubCategoryTableViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import UIKit
import CoreData

class SubCategoryTableViewController: UITableViewController {

    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    private var subCategoryList: [SubcategoryMO] = []
    private var selectedSubcategory: SubcategoryMO! = nil
    var category: CategoryMO! = nil
    
    //Gets the strings stored in the Strings.plist file
    lazy private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        loadData()
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
        
        //Hide separtor lines after empty cells in table view
        self.tableView.tableFooterView = UIView()
        
        //Set view label text
        if category == nil {
            self.title = strings["RepairCategoryName"] as? String
        } else {
            self.title = category?.categoryName
        }
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

    //Segue to BusinessListTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusinessList" {
            let businessListVC = segue.destination as! BusinessListTableViewController
            businessListVC.subcategory = selectedSubcategory
            businessListVC.category = category
        }
    }
    
    
    /*****************************************************************************/
    // MARK: - Table view data source
    
    //Load from core data model
    private func loadData() {
    
        if category !=  nil {
            // Load Subcategories from core data model
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let request: NSFetchRequest<SubcategoryMO> = SubcategoryMO.fetchRequest()
                let context = appDelegate.persistentContainer.viewContext
                
                //Refine request. In this case, return all subcategories of given category
                let predicate = NSPredicate(format: "category.categoryName CONTAINS[cd] %@", category.categoryName!)
                request.predicate = predicate
                
                //Sort results by subcategory name
                let sortDescriptor = NSSortDescriptor(key: "subCategoryName", ascending: true)
                request.sortDescriptors = [sortDescriptor]
                
                do {
                    subCategoryList = try context.fetch(request)
                } catch {
                    let fetchRequestError = ErrorHandler.errorAlertAction(strings["errorTitle"] as! String, strings["errorUnrecognized"] as! String)
                    present(fetchRequestError, animated: true, completion:  nil)
                }
            }
        }
    }
    
    //Number of TableView sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in TableView section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategoryList.count
    }

    //List subcategories from results
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = subCategoryList[indexPath.row].subCategoryName
        return cell
    }
 
    //Perform action for selected subcategory
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubcategory = subCategoryList[indexPath.row]
        performSegue(withIdentifier: "showBusinessList", sender: self)
    }
}
