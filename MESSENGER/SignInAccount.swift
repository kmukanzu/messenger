//
//  SignInAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class SignInAccount : UIViewController {
    
    @IBAction func dismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInOutlet: UIButton!
    @IBAction func signInButton(sender: AnyObject) {
        
    }
    
    @IBAction func forgotPasswordButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.emailTextField .becomeFirstResponder()
        signInOutlet.layer.cornerRadius = 8
        signInOutlet.layer.masksToBounds = true
        UIApplication.sharedApplication().statusBarHidden = true*/
    }
}