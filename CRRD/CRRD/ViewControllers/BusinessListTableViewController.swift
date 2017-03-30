//
//  BusinessListTableViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import UIKit
import CoreData

class BusinessListTableViewController: UITableViewController {

    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    private var businessList: [BusinessMO] = []
    private var selectedBusiness: BusinessMO! = nil
    var subcategory: SubcategoryMO! = nil
    var category: CategoryMO! = nil
    var recycleBusinesses: Bool = false
    
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
        
        //Set view label text
        if recycleBusinesses {
            self.title = strings["RecyclingInfoActivityLabel"] as! String?
        } else {
            self.title = subcategory?.subCategoryName
        }
        
        //Hide separtor lines after empty cells in table view
        self.tableView.tableFooterView = UIView()
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
    
    //Segue to BusinessDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            let businessDetailsVC = segue.destination as! BusinessDetailsViewController
            businessDetailsVC.business = selectedBusiness
        }
    }
    
    
    /*****************************************************************************/
    // MARK: - Table view data source

    //Load from core data model
    private func loadData() {
        
        //Load Businesses from core data model
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<BusinessMO> = BusinessMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            //Refine request to businesses from a particular category
            if subcategory != nil && category != nil {
                
                //Refine request. In this case, return all business of given subcategory
                let predicate = NSPredicate(format: "category.categoryName CONTAINS[cd] %@ && subcategory.subCategoryName CONTAINS[cd] %@", category.categoryName!, subcategory.subCategoryName!)
                request.predicate = predicate
            }
            
            if recycleBusinesses {
                
                //Refine request. In this case, return all recycle businesses
                let predicate = NSPredicate(format: "recycleBusiness == true")
                request.predicate = predicate
            }
            
            //Sort results by business name
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            do {
                businessList = try context.fetch(request)
            } catch {
                let fetchRequestError = ErrorHandler.errorAlertAction(strings["errorTitle"] as! String, strings["errorUnrecognized"] as! String)
                present(fetchRequestError, animated: true, completion:  nil)
            }
        }
    }
    
    //Number of TableView sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Number of rows in TableView section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    //List businesses from results
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = businessList[indexPath.row].name
        return cell
    }

    //Perform action for selected business
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBusiness = businessList[indexPath.row]
        performSegue(withIdentifier: "showBusiness", sender: self)
    }
}
