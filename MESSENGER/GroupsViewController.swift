//
//  GroupsViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/27/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class GroupsViewController : UIViewController {
    
    @IBAction func searchGroupsButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToSearchGroups", sender: self)
    }
}