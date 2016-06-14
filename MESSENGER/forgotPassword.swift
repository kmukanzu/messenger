//
//  forgotPassword.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/11/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class forgotPassword : UITableViewController {
    
    var signInError : UIAlertController?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailIcon: UIImageView!
    
    @IBAction func requestButton(sender: AnyObject) {
        
        self.view.userInteractionEnabled = false
        self.navigationItem.backBarButtonItem?.enabled = false
        
        if emailTextField != "" {
            
            userPasswordRecoveryAsync()
            
        } else {
            
            self.presentViewController(signInError!, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.emailTextField .becomeFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.autocorrectionType = .No
        
        self.emailIcon.image = UIImage(named: "email.png")
        
        signInError = UIAlertController(title: "Email Error!", message: "Please check the email you entered", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            
            self.view.userInteractionEnabled = true
            self.navigationItem.backBarButtonItem?.enabled = true
            
        }
        signInError?.addAction(button)
   
    }
    
    func userPasswordRecoveryAsync() {
        
        backendless.userService.restorePassword( emailTextField.text, response:{ ( result : AnyObject!) -> () in
            print("Check your email address! result = \(result)")
            },
            error: { ( fault : Fault!) -> () in
            print("Server reported an error: \(fault)")
                                                    
            self.presentViewController(self.signInError!, animated: true, completion: nil)
            }
        )
    }
}