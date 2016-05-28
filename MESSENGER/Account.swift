//
//  Account.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/27/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class Account: UITableViewController {
    
    @IBOutlet weak var signOutCell: UITableViewCell!
    @IBOutlet weak var deleteAccountCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return signOutCell   }
        if ((indexPath.section == 0) && (indexPath.row == 1)) { return deleteAccountCell }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            print("SignOut")
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            print("DeleteAccount")
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}