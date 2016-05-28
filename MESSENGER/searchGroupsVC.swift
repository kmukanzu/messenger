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
    
    var groupName = String()
    var groupPassword = String()
    var universityID = String()
    var creator = String()
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButton(sender: AnyObject) {
        self.presentViewController(self.createGroupAlert!, animated: true, completion: nil)
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
    }
    
    func createGroup () {
    
        firebase.child("Universities").child(self.universityID).child("Groups").childByAutoId().setValue(["groupName": self.groupName, "groupPassword" : self.groupPassword, "groupCreator": self.creator])
    
    }
    
    
    
    
    
}