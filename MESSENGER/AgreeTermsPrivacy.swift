//
//  AgreeTermsPrivacy.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/4/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class AgreeTermsPrivacy : UITableViewController {

    @IBOutlet weak var termsCell: UITableViewCell!
    @IBOutlet weak var privacyCell: UITableViewCell!
    
    @IBAction func AgreeButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("TermsToCreateAccount", sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return termsCell   }
        if ((indexPath.section == 0) && (indexPath.row == 1)) { return privacyCell }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToTerms", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            self.performSegueWithIdentifier("goToPrivacy", sender: self)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}