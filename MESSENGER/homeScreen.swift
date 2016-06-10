//
//  homeScreen.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/8/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class homeScreen : UIViewController {
    
    var alertController : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        alertController = UIAlertController(title: "Hello", message: "You are currently not signed in. What would you like to do?", preferredStyle: .Alert)
        
        let signInAction = UIAlertAction(title: "Sign in", style: .Default) { (action) -> Void in
            print("Sign in button was pressed")
            //self.presentViewController(self.signInAlert!, animated: true, completion: nil)
        }
        let signUpAction = UIAlertAction(title: "Create account", style: .Default) { (action) -> Void in
            print("Sign up button was pressed")
            
            self.performSegueWithIdentifier("AgreeToTermsPrivacy", sender: self)
            
            //self.presentViewController(self.newAccountAlert!, animated: true, completion: nil)
            
        }
        
        alertController?.addAction(signInAction)
        
        alertController?.addAction(signUpAction)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.presentViewController(self.alertController!, animated: true, completion: nil)
        
    }
}