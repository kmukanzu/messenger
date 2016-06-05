//
//  AgreeTermsPrivacy.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/4/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class AgreeTermsPrivacy : UITableViewController {

    @IBAction func AgreeButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("TermsToCreateAccount", sender: self)
    }
    
}