//
//  GroupInfoViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/29/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class GroupInfoViewController : UIViewController {
    
    @IBAction func optionButton(sender: AnyObject) {
        
        //if currentUser is member present leaveGroup(), if currentUser is creator present adminOptions(),
        
        joinGroup()
    }
    
    func joinGroup() {
        
        let joinAction = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let join = UIAlertAction(title: "Join Group", style: .Default) { (Alert:UIAlertAction) -> Void in
            print("join button was pressed")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
            
        }
        
        joinAction.addAction(join)
        joinAction.addAction(cancel)
        
        self.presentViewController(joinAction, animated: true, completion: nil)
        
    }
    
    func leaveGroup() {
        
        let leaveAction = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let leave = UIAlertAction(title: "Leave Group", style: .Destructive) { (Alert:UIAlertAction) -> Void in
            print("leave button was pressed")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
            
        }
        
        leaveAction.addAction(leave)
        leaveAction.addAction(cancel)
        
        self.presentViewController(leaveAction, animated: true, completion: nil)
        
    }
    
    func adminOptions() {
        
        let leaveAction = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let name = UIAlertAction(title: "Edit Name", style: .Destructive) { (Alert:UIAlertAction) -> Void in
            print("leave button was pressed")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
            
        }
        
        leaveAction.addAction(name)
        leaveAction.addAction(cancel)
        
        self.presentViewController(leaveAction, animated: true, completion: nil)
        
    }
}