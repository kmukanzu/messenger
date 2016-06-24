//
//  MessagesTableViewCell.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/2/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import SDWebImage

class MessagesTableViewCell : UITableViewCell {
    
    let backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    func bindData(recent: NSDictionary){
        
        avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame)/4.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 0.2
        avatarImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        counterView.layer.cornerRadius = counterView.frame.size.width/2
        counterView.layer.masksToBounds = true
        
        self.avatarImageView.image = UIImage(named: "")
        
        let withUserId = (recent.objectForKey("withUserUserId") as? String)!
        
        //get the backendless user and download avatar
        
        let whereClause = "objectId = '\(withUserId)'"
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
        
        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
            
            let withUser = users.data.first as! BackendlessUser
            
            if let avatarURL = withUser.getProperty("Avatar") {
                getImageFromURL(avatarURL as! String, result: { (image) -> Void in
                    
                    self.avatarImageView.image = image
                   
                })
            }
            
            }) { (fault: Fault!) -> Void in
                
                print("error, couldnt get user avatar: \(fault)")
        }
        
        nameLabel.text = recent["withUserUsername"] as? String
        lastMessageLabel.text = recent["lastMessage"] as? String
        counterLabel.text = ""
        counterView.hidden = true
        
        
        
        if (recent["counter"] as? Int)! != 0 {
            counterLabel.text = "\(recent["counter"]!)"
            //nameLabel.font = UIFont.boldSystemFontOfSize(16.0)
            counterView.hidden = false
            
        }
        
        let date = dateFormatter().dateFromString((recent["date"] as? String)!)
        timeLabel.text = NSDateFormatter.friendlyStringForDate(date!)
    }
}