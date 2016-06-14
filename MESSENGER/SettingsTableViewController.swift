//
//  SettingsTableViewController.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/22/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import MessageUI

class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBAction func doneButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var profileCell: UITableViewCell!
    @IBOutlet weak var supportCell: UITableViewCell!
    @IBOutlet weak var reportCell: UITableViewCell!
    @IBOutlet weak var termsCell: UITableViewCell!
    @IBOutlet weak var inviteCell: UITableViewCell!
    @IBOutlet weak var accountCell: UITableViewCell!
    
    var editFullName : UIAlertController?
    var reportAlert : UIAlertController?
    
    var sendMailErrorAlert : UIAlertController?
    
    var fullName = String()
    var issue = String()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var firstLoad: Bool?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame)/4.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 0.4
        avatarImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        updateUI()
        
        editFullName = UIAlertController(title: "Edit Name", message: "Please enter your full name", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) -> Void in
            print("Cancel button was pressed")
        }
        self.editFullName?.addAction(cancel)
        
        editFullName?.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Full Name"
            textfield.text = backendless.userService.currentUser.name
            textfield.autocapitalizationType = UITextAutocapitalizationType.Words
        })
        
        let alertActionForTextFields = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            
            if let textFields = self.editFullName?.textFields {
                let theTextFields = textFields as [UITextField]
                let fullNameTextField = theTextFields[0].text
                print("\(fullNameTextField)")
                
                self.fullName = fullNameTextField!
                
                let properties = ["name" : fullNameTextField!]
                
                backendless.userService.currentUser.updateProperties(properties)
                
                backendless.userService.update(backendless.userService.currentUser, response: { (updatedUser: BackendlessUser!) -> Void in
                    
                    self.nameLabel.text = self.fullName
                    
                    }, error: { (fault : Fault!) -> Void in
                        print("error: \(fault)")
                })
                
                //self.nameLabel.text = self.fullName
                
            }
            
        }
        
        editFullName?.addAction(alertActionForTextFields)
        
        sendMailErrorAlert = UIAlertController(title: "Error!", message: "Message unable to send. Check your network connection", preferredStyle: .Alert)
        let cancels = UIAlertAction(title: "OK", style: .Cancel) { (action:UIAlertAction!) -> Void in
            
            print("Cancel button was pressed")
        }
        
        self.sendMailErrorAlert?.addAction(cancels)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        if section == 1 { return 3 }
        if section == 2 { return 1 }
        if section == 3 { return 1 }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if ((indexPath.section == 0) && (indexPath.row == 0)) { return profileCell }
        if ((indexPath.section == 1) && (indexPath.row == 0)) { return supportCell }
        if ((indexPath.section == 1) && (indexPath.row == 1)) { return reportCell  }
        if ((indexPath.section == 1) && (indexPath.row == 2)) { return termsCell   }
        if ((indexPath.section == 2) && (indexPath.row == 0)) { return inviteCell  }
        if ((indexPath.section == 3) && (indexPath.row == 0)) { return accountCell }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            editProfile()
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            //inviteAFriend()
            invite()
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                
            } else {
            
                self.presentViewController(sendMailErrorAlert!, animated: true, completion: nil)
                
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToSupport", sender: self)
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            //print("goToTermsAndPrivacy")
            self.performSegueWithIdentifier("goToTermsAndPrivacy", sender: self)
        }
        
        if indexPath.section == 3 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToAccount", sender: self)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        avatarImageView.image = image
        
        uploadAvatar(image) { (imageLink) -> Void in
            
            let properties = ["Avatar" : imageLink!]
            
            backendless.userService.currentUser!.updateProperties(properties)
            
            backendless.userService.update(backendless.userService.currentUser, response: { (updatedUser: BackendlessUser!) -> Void in
                
                }, error: { (fault : Fault!) -> Void in
                    print("error: \(fault)")
            })
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func updateUI() {
        
        nameLabel.text = backendless.userService.currentUser.name
        emailLabel.text = backendless.userService.currentUser.email
        
        if let imageLink = backendless.userService.currentUser.getProperty("Avatar") {
            getImageFromURL(imageLink as! String, result: { (image) -> Void in
                
                self.avatarImageView.image = image
            })
        }
    }
    
    func editProfile() {
        
    
        //self.tabBarController?.tabBar.hidden = true
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let editName = UIAlertAction(title: "Edit Name", style: .Default) { (Alert:UIAlertAction) -> Void in
            print("Edit Name button was pressed")
            
            self.presentViewController(self.editFullName!, animated: true, completion: nil)
            
            
        }
        let editImage = UIAlertAction(title: "Change Image", style: .Default) { (Alert:UIAlertAction) -> Void in
            print("Edit Image button was pressed")
            self.tabBarController?.tabBar.hidden = false
            
            let camera = Camera(delegate_: self)
            camera.PresentPhotoLibrary(self, canEdit: true)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
            self.tabBarController?.tabBar.hidden = false
        }
        actionAlert.addAction(editName)
        actionAlert.addAction(editImage)
        actionAlert.addAction(cancel)
        
        self.presentViewController(actionAlert, animated: true, completion: nil)
    
    }
    
    func inviteAFriend() {
    
        //self.tabBarController?.tabBar.hidden = true
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let mail = UIAlertAction(title: "Mail", style: .Default) { (Alert:UIAlertAction) -> Void in
            print("mail button was pressed")
            self.tabBarController?.tabBar.hidden = false
            
        }
        let message = UIAlertAction(title: "Message", style: .Default) { (Alert:UIAlertAction) -> Void in
            print("message button was pressed")
            self.tabBarController?.tabBar.hidden = false
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (Alert:UIAlertAction) -> Void in
            print("Cancel")
            self.tabBarController?.tabBar.hidden = false
        }
        actionAlert.addAction(mail)
        actionAlert.addAction(message)
        actionAlert.addAction(cancel)
        
        self.presentViewController(actionAlert, animated: true, completion: nil)
    
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["admin@universitymessenger.org"])
        mailComposerVC.setSubject("Reporting an issue")
        mailComposerVC.setMessageBody("Hi Team!\n\nI would like to share the following issue(s)..\n", isHTML: false)
        
        return mailComposerVC
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func invite() {
        
        let vc = UIActivityViewController(activityItems: ["Hey check out University Messenger. Download the app on universitymessenger.org/download"], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
}