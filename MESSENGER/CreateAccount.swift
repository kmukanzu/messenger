//
//  CreateAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

class CreateAccount : UIViewController {
    
    //var firebase = FIRDatabase.database().reference()
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var currentUser: BackendlessUser?
    
    var email: String?
    var fullName: String?
    var password: String?
    var universityID: String?
    var universityName: String?
    var avatarImage: UIImage?
    
    var userEmail = String()
    var userFullName = String()
    var userPassword = String()
    var userUniversityName = String()
    var userUniversityID = String()
    var userName = String()
    
    var emailVerificationAlert : UIAlertController?
    var signInAlert : UIAlertController?
    var resetPasswordAlert : UIAlertController?
    var passwordReset : UIAlertController?
    var passwordHasReset : UIAlertController?
    var signUpError : UIAlertController?
    
    @IBAction func dismissCreateAccount(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var createAccountOutlet: UIButton!
    
    @IBAction func createAccountAction(sender: AnyObject) {
        
    }
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullNameTextField .becomeFirstResponder()
        createAccountOutlet.layer.cornerRadius = 8
        createAccountOutlet.layer.masksToBounds = true
        UIApplication.sharedApplication().statusBarHidden = true
        
        newUser = BackendlessUser()
        
        signUpError = UIAlertController(title: "Sign up Error!", message: "Sign up using your university email address", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            print("Ok button was pressed")
            
        }
        
        signUpError?.addAction(button)
        
        
        
        
    }
    
    func resister(email: String, fullName: String, password: String, universityID: String, avatarImage: UIImage?){
        
        if avatarImage == nil {
            newUser?.setProperty("Avatar", object: "")
            
        }
        newUser?.setProperty("universityID", object: universityID)
        newUser?.email = email
        newUser?.name = fullName
        newUser?.password = password
        
        backendless.userService.registering(newUser, response: { (registeredUser : BackendlessUser!) -> Void in
            
            self.presentViewController(self.emailVerificationAlert!, animated: true, completion: nil)
            
            if let range = email.rangeOfString("@") {
                
                self.userName = email.substringToIndex(range.startIndex)
                print(self.userName)
                
            }
            
            /*firebase.child("Users").child(self.userUniversityID).child(self.userName).setValue(["fullName": self.userFullName, "userEmail" : self.userEmail])*/
            
            }) { (fault : Fault!) -> Void in
                print("\(fault)")
                
                self.presentViewController(self.signUpError!, animated: true, completion: nil)
        }
    }
}