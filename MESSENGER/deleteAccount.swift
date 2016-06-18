//
//  deleteAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/11/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import UIKit

class deleteAccount : UITableViewController {
    
    var deleteError : UIAlertController?
    var passwordError : UIAlertController?
    
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func deleteAccountButton(sender: AnyObject) {
        
        if emailTextField.text != "" {
            
            self.presentViewController(deleteError!, animated: true, completion: nil)
            
        } else {
        
            self.presentViewController(passwordError!, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordIcon.image = UIImage(named: "lock.png")
        emailTextField.secureTextEntry = true
        
        deleteError = UIAlertController(title: "Deletion Error!", message: "Unable to delete account. Contact our team by reporting a problem.", preferredStyle: .Alert)
        let button = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        deleteError?.addAction(button)
        
        passwordError = UIAlertController(title: "Password Error!", message: "Please enter your password.", preferredStyle: .Alert)
        let OKbutton = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            
            //self.navigationController?.popViewControllerAnimated(true)
        }
        
        passwordError?.addAction(OKbutton)
        
    }
}