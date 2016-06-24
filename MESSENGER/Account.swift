//
//  Account.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/27/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class Account: UITableViewController {
    
    @IBOutlet weak var signOutCell: UITableViewCell!
    @IBOutlet weak var deleteAccountCell: UITableViewCell!
    
    var signOutAlert : UIAlertController?
    var deleteAccountAlert : UIAlertController?
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityInd =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let barButton = UIBarButtonItem(customView: activityInd)
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        activityInd.color = UIColor.lightGrayColor()
        
        self.activityIndicator = activityInd
        
        signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
            print("Cancel button was pressed")
            
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            print("Yes button was pressed")
            
            self.activityIndicator.startAnimating()
            self.logOut()
            
            
            
        }
        
        signOutAlert?.addAction(cancelAction)
        
        signOutAlert?.addAction(yesAction)
        
        deleteAccountAlert = UIAlertController(title: "Delete Account", message: "All your messages and data will be permanently deleted", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (action) -> Void in
            print("Cancel button was pressed")
            
        }
        
        deleteAccountAlert?.addAction(cancel)
        
        /*deleteAccountAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Email"
            textfield.text = backendless.userService.currentUser.email
            
        })*/
        
        deleteAccountAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
            textfield.text = ""
            textfield.secureTextEntry = true
        })
        
        let alertActionForTextFields = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            
            if let textFields = self.deleteAccountAlert?.textFields {
                let theTextFields = textFields as [UITextField]
                let emailTextField = backendless.userService.currentUser.email
                let passwordTextField = theTextFields[0].text
                print("\(passwordTextField)")
                
                if passwordTextField != ""{
                    
                    self.AuthUser(emailTextField, password: passwordTextField!)
                    
                } else {
                    
                    
                    
                    //self.presentViewController(self.signInError!, animated: true, completion: nil)
                }
            }
            
        }
        
        deleteAccountAlert?.addAction(alertActionForTextFields)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return signOutCell   }
        if ((indexPath.section == 0) && (indexPath.row == 1)) { return deleteAccountCell }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            //self.activityIndicator.startAnimating()
            self.view.userInteractionEnabled = false
            
            self.presentViewController(signOutAlert!, animated: true, completion: nil)
            
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            print("DeleteAccount")
        
            self.performSegueWithIdentifier("goToDeleteAccount", sender: self)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func logOut() {
        
        removeDeviceIdFromUser()
    
        backendless.userService.logout()
        
        PushUserResign()
        
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("WelcomeScreen") as! UINavigationController
        self.presentViewController(homeVC, animated: false, completion: nil)
    }
    
    func AuthUser (email: String, password: String){
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) -> Void in
            
            //self.performSegueWithIdentifier("goToMessages", sender: self)
            
            // Delete user from backendless
            // Delete user from firebase
            
            }) { (fault:Fault!) -> Void in
                print("\(fault)")
                
                //self.presentViewController(self.signInError!, animated: true, completion: nil)
        }
    }
}