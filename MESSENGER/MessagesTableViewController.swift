//
//  MessagesTableViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/2/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import SDWebImage

class MessagesTableViewController : UITableViewController, ChooseUserDelegate {
    
    var recents : [NSDictionary] = []
    
    var universityID = String()
    
    var users: [BackendlessUser] = []
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }
    
    @IBAction func moreButton(sender: AnyObject) {
        
        //options()
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if recents.count > 0 {
            
            self.tableView.backgroundView = nil
            numOfSection = 1
            
            
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            
            noDataLabel.text = ""
            noDataLabel.textColor = UIColor.grayColor()
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = noDataLabel
            
            delay(1.0){
            noDataLabel.text = "You don't have any messages."
                
            }
        }
        
        return numOfSection
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
        
        let email = backendless.userService.currentUser.email
        let university = self.getMainPart2(email)
        let dotEdu = self.getMainPart1(email)
        self.universityID = university + dotEdu
        
        loadRecents()
        
        loadUsers()
        
        tableView.tableFooterView = UIView()
        
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
                    
                    //add function to have offline access as well, this will download with user recent as well so that we will not create it again
                    
                    firebase.child("Recent").queryOrderedByChild("chatRoomID").queryEqualToValue(recent["chatRoomID"]).observeEventType(.Value, withBlock: {
                        snapshot in
                    })
                    
                }
                
            }
            
            self.tableView.reloadData()
        })
    }
    
    func options() {
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let editSettings = UIAlertAction(title: "Settings", style: .Default) { (Alert:UIAlertAction) -> Void in
            self.performSegueWithIdentifier("messagesToSettings", sender: self)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
        }
        actionAlert.addAction(editSettings)
        actionAlert.addAction(cancel)
        
        self.presentViewController(actionAlert, animated: true, completion: nil)
        
    }
    
    func loadUsers() {
        
        let whereClause = "objectId != '\(backendless.userService.currentUser.objectId)' AND UniversityID = '\(self.universityID)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let queryOptions = QueryOptions()
        queryOptions.sortBy = ["name"]
        dataQuery.queryOptions = queryOptions
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            self.users = users.data as! [BackendlessUser]
            
            self.tableView.reloadData()
            
        }) { (fault : Fault!) -> Void in
            print("Error, couldnt retrive users: \(fault)")
        }
    }
}