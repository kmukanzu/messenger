//
//  MessagesTableViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/2/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class MessagesTableViewController : UITableViewController, ChooseUserDelegate {
    
    var recents : [NSDictionary] = []
    
    @IBAction func moreButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messagesToSettings", sender: self)
    }
    
    @IBAction func newMessage(sender: AnyObject) {
        
        self.performSegueWithIdentifier("messagesToSearchUser", sender: self)
    }
    
    func CreateChatroom(withUser: BackendlessUser) {
        
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)
        
        chatVC.withUser = withUser
        chatVC.chatRoomId = startChat(backendless.userService.currentUser, user2: withUser)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "messagesToSearchUser" {
            let vc = segue.destinationViewController as! UINavigationController
            let DestVc = vc.topViewController as! SearchUserViewController
            DestVc.delegate = self
            
        }
        
        if segue.identifier == "messageToChat" {
            let indexPath = sender as! NSIndexPath
            let chatVC =  segue.destinationViewController as! ChatViewController
            
            let recent = recents[indexPath.row]
            
            chatVC.recent = recent
            
            chatVC.chatRoomId = recent["chatRoomID"] as? String
            chatVC.navTitle = (recent["withUserUsername"] as? String)!
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MessagesTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let recent = recents[indexPath.row]
        
        RestartRecentChat(recent)
        
        performSegueWithIdentifier("messageToChat",
            sender: indexPath)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let recent = recents[indexPath.row]
        
        //remove recent from the array
        recents.removeAtIndex(indexPath.row)
        
        //delete recent from firebase
        DeleteRecentItem(recent)
        
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        
        loadRecents()
        
        //self.tabBarController?.tabBar.hidden = true
        
        tableView.tableFooterView = UIView()
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    func loadRecents() {
        
        firebase.child("Recent").queryOrderedByChild("userId").queryEqualToValue(backendless.userService.currentUser.objectId).observeEventType(.Value, withBlock: {
            snapshot in
            
            self.recents.removeAll()
            
            if snapshot.exists() {
                
                let sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                
                for recent in sorted {
                    
                    self.recents.append(recent as! NSDictionary)
                    
                    //add functio to have offline access as well, this will download with user recent as well so that we will not create it again
                    
                    firebase.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(recent["chatRoomID"]).observeEventType(.Value, withBlock: {
                        snapshot in
                    })
                    
                }
                
            }
            
            self.tableView.reloadData()
        })
    }
    
    func edit() {
        
        
        //self.tabBarController?.tabBar.hidden = true
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let editSettings = UIAlertAction(title: "Settings", style: .Default) { (Alert:UIAlertAction) -> Void in
            self.performSegueWithIdentifier("goToSettings", sender: self)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
        }
        actionAlert.addAction(editSettings)
        actionAlert.addAction(cancel)
        
        self.presentViewController(actionAlert, animated: true, completion: nil)
        
    }
}