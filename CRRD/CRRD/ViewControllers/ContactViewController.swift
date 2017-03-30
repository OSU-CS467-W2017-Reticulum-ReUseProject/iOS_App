//
//  ContactViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 Fahmy Mohammed. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    //Holds CSC mail, online, facebook ,and twitter details used in the table view cells.
    private struct ContactDetails {
        var identifier = ""
        var link = ""
        var image: UIImage! = nil
    }
    
    @IBOutlet weak var dropDownMenuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var aboutContact: UILabel!
    private var contactDetails: [ContactDetails] = []
    
    //Gets the strings stored in the Strings.plist file
    lazy private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        populateContactDetails()
    }
    
    //Add CSC mail, online facebook and twitter info
    private func populateContactDetails() {
        
        //Add CSC email details
        contactDetails.append(ContactDetails(identifier: "mail", link: ((strings["CSCEmail"]) as! String?)!, image: #imageLiteral(resourceName: "email_black")))
        
        //Add CSC online details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCOnline"]) as! String?)!, image: #imageLiteral(resourceName: "public_black")))
        
        //Add CSC facebook details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCFacebook"]) as! String?)!, image: #imageLiteral(resourceName: "facebook_black")))
        
        //Add CSC twitter details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCTwitter"]) as! String?)!, image: #imageLiteral(resourceName: "twitter_black")))
    }

    
    /*****************************************************************************/
    //MARK: - Theme
    
    //Adjusts appearance of items in view
    private func viewTheme() {
        
        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Move the home and drop down menu buttons further to the right
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -6
        self.navigationItem.setRightBarButtonItems([negativeSpacer, dropDownMenuButton, homeButton], animated: false)
        
        //Set view label text
        self.title = strings["ContactActivityLabel"] as! String?
        contactLabel.text = strings["ContactCSCLabel"] as! String?
        aboutContact.text = strings["AboutContact"] as! String?
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
    
    //Displays an alert on the screen and prompts the user with a choice to navigate to the link
    func openLink(_ link: String) {
        
        //Setup alert menu
        let alertMenu = ErrorHandler.errorAlertMenu("", "Open Link")
        
        //Setup action that allows the user to open the link when pressed
        let actionHandler = { (action:UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: link)! as URL)
        }
        let linkAction = UIAlertAction(title: "\(link)", style: .default, handler: actionHandler)
        
        //Add call and cancel actions to the alert menu
        alertMenu.addAction(linkAction)
        
        //If the device is an iPad, the alert menu needs to be displayed using the PopoverPresentationController
        if let alertMenuPopover = alertMenu.popoverPresentationController {
            //Setup PopoverPresentationController
            alertMenuPopover.sourceView = self.view
            alertMenuPopover.sourceRect = CGRect(x: self.view.bounds.midX, y: 0, width: 0, height: 0) //Center alert menu
            alertMenuPopover.permittedArrowDirections = .up
        }
        
        self.present(alertMenu, animated: true, completion:  nil)
    }

    //Action performed when CSC email link is pressed
    private func openEmail(_ subject: String, _ email: String) {
        
        //Check if device is configured to send mail
        if MFMailComposeViewController.canSendMail() {
            
            //Reference to mailcompose view controller
            let mailCompose = MFMailComposeViewController()
            
            //Setup mailcompose view controller
            mailCompose.mailComposeDelegate = self
            mailCompose.setSubject(subject)
            mailCompose.setToRecipients([email])
            mailCompose.navigationBar.tintColor = UIColor.white
            mailCompose.navigationItem.titleView?.tintColor = UIColor.white
            
            //Present mailcompose view controller
            present(mailCompose, animated: true, completion: nil)
        } else {
            let mailComposeViewError = ErrorHandler.errorAlertAction(strings["errorTitle"] as! String, strings["errorUnrecognized"] as! String)
            present(mailComposeViewError, animated: true, completion:  nil)
        }
    }
    
    //Allows access to MFMailComposeViewController result and dismisses view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    
    /*****************************************************************************/
    // MARK: - Table view data source
    
    //Number of rows in table view section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetails.count
    }
    
    //Display contact details in table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell uses ContactDetailCell as template
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell", for: indexPath) as! DetailTableViewCell
        
        //Wrap characters if URL is too long for one line
        cell.contactCellLabelValue.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        //Configure table view cell
        cell.contactCellLabelValue.text = contactDetails[indexPath.row].link
        cell.contactCellImage.image = contactDetails[indexPath.row].image
        
        //Change image tint and label text color
        cell.contactCellLabelValue.textColor = Utils.Colors.cscBlue
        cell.contactCellImage.tintColor = Utils.Colors.cscBlue
        cell.contactCellImage.tintAdjustmentMode = .normal
        
        return cell
    }
    
    //Perform action for selected contact detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Action for opening link, mail or address
        switch contactDetails[indexPath.row].identifier {
        case "mail":
            openEmail((strings["CSCInfoEmailSubject"] as! String), contactDetails[indexPath.row].link)
        case "link":
            openLink(contactDetails[indexPath.row].link)
        default:
            break
        }
    }
}



