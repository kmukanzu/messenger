//
//  SignInAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class SignInAccount : UIViewController {
    
    @IBOutlet weak var signInView: UIView!
    @IBAction func dismissSignInAccount(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        signInView.layer.cornerRadius = 8
        signInView.layer.masksToBounds = true
        signInView.layer.borderWidth = 1
    }
}