//
//  Welcome.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class Welcome : UIViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInAccountButton: UIButton!
    
    
    @IBAction func createAccount(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToCreateAccount", sender: self)
    }
    
    @IBAction func SignInAccount(sender: AnyObject) {

        self.performSegueWithIdentifier("goToSignInAccount", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarHidden = true
        
        createAccountButton.layer.cornerRadius = 8
        //createAccountButton.layer.masksToBounds = false
        createAccountButton.layer.masksToBounds = true
    }
    
    
}