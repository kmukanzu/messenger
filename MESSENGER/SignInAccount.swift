//
//  SignInAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class SignInAccount : UITableViewController {
    
    var firebase = FIRDatabase.database().reference()
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var currentUser: BackendlessUser?
    
    var email: String?
    var fullName: String?
    var password: String?
    var universityID: String?
    var universityName: String?
    var avatarImage: UIImage?
    
    @IBAction func cancelBarButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(sender: AnyObject) {
        
        if emailTextField != "" && passwordTextField != "" {
            
            self.email = emailTextField.text
            self.password = passwordTextField.text
            
            loginUser(email!, password: password!)
        }
    }
    
    @IBAction func forgotPasswordButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField .becomeFirstResponder()
        passwordTextField.secureTextEntry = true
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        
    }
    
    func loginUser (email: String, password: String) {
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) -> Void in
            
            self.performSegueWithIdentifier("goToMessages", sender: self)
            
        }) { (fault:Fault!) -> Void in
            print("\(fault)")
            
            //self.presentViewController(self.signInError!, animated: true, completion: nil)
        }
    }
}