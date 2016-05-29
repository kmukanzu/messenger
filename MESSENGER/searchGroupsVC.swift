//
//  searchGroupsVC.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/25/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class searchGroupsVC: UITableViewController {
    
    var createGroupAlert : UIAlertController?
    var passwordAlert : UIAlertController?
    
    var groupName = String()
    var groupPassword = String()
    var universityID = String()
    var creator = String()
    var password = String()
    
    // IN DIDSELECT ROW AT INDEX PATH
    // IF groupPassWord =! nil, present passwordAlert
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        self.presentViewController(self.passwordAlert!, animated: true, completion: nil)
    }
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGroupAlert = UIAlertController(title: "New Group", message: "Give your group a unique name.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) -> Void in
            print("Cancel button was pressed")
        }
        self.createGroupAlert?.addAction(cancel)
        
        createGroupAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Group Name"
            textfield.text = ""
            textfield.autocapitalizationType = UITextAutocapitalizationType.Words
        })
        
        createGroupAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password (Optional)"
            textfield.text = ""
            textfield.secureTextEntry = true
        })
        
        let alertActionForTextFields = UIAlertAction(title: "Create", style: .Default) { (action) -> Void in
            
            if let textFields = self.createGroupAlert?.textFields {
                let theTextFields = textFields as [UITextField]
                let groupNameTextField = theTextFields[0].text
                print("\(groupNameTextField)")
                
                let passwordTextField = theTextFields[1].text
                print("\(passwordTextField)")
                
                let email = backendless.userService.currentUser.email
                let university = self.getMainPart2(email)
                let dotEdu = self.getMainPart1(email)
                self.universityID = university + dotEdu
                
                self.groupName = groupNameTextField!
                self.groupPassword = passwordTextField!
                self.creator = backendless.userService.currentUser.objectId
                
                if groupNameTextField != "" {
                    
                    self.createGroup()
                
                }
                
            }
            
        }
        
        createGroupAlert?.addAction(alertActionForTextFields)
        
        passwordAlert = UIAlertController(title: "Peassword", message: "Enter group password", preferredStyle: .Alert)
        let cancelbutton = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) -> Void in
            print("Cancel button was pressed")
        }
        self.passwordAlert?.addAction(cancelbutton)
        
        passwordAlert?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
            textfield.text = ""
            textfield.secureTextEntry = true
        })
        
        let alertActionForTextFieldss = UIAlertAction(title: "Next", style: .Default) { (action) -> Void in
            
            if let textFields = self.passwordAlert?.textFields {
                let theTextFields = textFields as [UITextField]
                
                let passwordTextField = theTextFields[0].text
                print("\(passwordTextField)")
                
                self.password = passwordTextField!
                
                if passwordTextField != "" {
                    
                    // Check Firebase if password = groupPassword
                    
                }
                
            }
            
        }
        
        passwordAlert?.addAction(alertActionForTextFieldss)
    }
    
    func createGroup () {
    
        firebase.child("Groups").child(self.universityID).childByAutoId().setValue(["groupName": self.groupName, "groupPassword" : self.groupPassword, "groupCreator": self.creator, "universityID" : self.universityID])
    
    }
    
}