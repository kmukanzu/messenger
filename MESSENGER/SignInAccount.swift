//
//  SignInAccount.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 5/31/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class SignInAccount : UITableViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    var firebase = FIRDatabase.database().reference()
    
    var backendless = Backendless.sharedInstance()
    
    var newUser: BackendlessUser?
    var currentUser: BackendlessUser?
    
    var userUniversityID = String()
    
    var activityIndicator = UIActivityIndicatorView()
    
    var email: String?
    var fullName: String?
    var password: String?
    var universityID: String?
    var universityName: String?
    var avatarImage: UIImage?
    
    var signUpError : UIAlertController?
    
    func getMainPart2(s: String) -> String {
        var v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        v?.removeLast()
        
        return (v!.last)!
    }
    
    func getMainPart1(s: String) -> String {
        let v = s.componentsSeparatedByString("@").last?.componentsSeparatedByString(".")
        
        return (v!.last)!
    }
    
    @IBAction func cancelBarButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signInButton(sender: AnyObject) {
        
        self.view.userInteractionEnabled = false
        cancelButtonOutlet.enabled = false
        
        if emailTextField != "" && passwordTextField != "" && emailTextField.text!.characters.indexOf("@") != nil && emailTextField.text!.characters.indexOf(".") != nil && emailTextField.text!.rangeOfString(".com") == nil {
            
            self.email = emailTextField.text
            self.password = passwordTextField.text
            
            let university = self.getMainPart2(emailTextField.text!)
            let dotEdu = self.getMainPart1(emailTextField.text!)
            self.userUniversityID = university + dotEdu
            
            self.activityIndicator.startAnimating()
            
            loginUser(email!, password: password!)
            
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        } else {

            self.activityIndicator.stopAnimating()
            presentViewController(signUpError!, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func forgotPasswordButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("goToForgotPassword", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileIcon.image = UIImage(named: "profile.png")
        self.passwordIcon.image = UIImage(named: "lock.png")
        
        self.emailTextField .becomeFirstResponder()
        passwordTextField.secureTextEntry = true
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.autocorrectionType = .No
        
        let activityInd =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let barButton = UIBarButtonItem(customView: activityInd)
        self.navigationItem.setLeftBarButtonItem(barButton, animated: true)
        activityInd.color = UIColor.lightGrayColor()
        
        self.activityIndicator = activityInd
        
        signUpError = UIAlertController(title: "Sign up Error!", message: "Sign up using your university email address", preferredStyle: .Alert)
        let button = UIAlertAction(title: "Try again", style: .Cancel) { (action) -> Void in
            
            self.view.userInteractionEnabled = true
            self.cancelButtonOutlet.enabled = true
            
            
        }
        signUpError?.addAction(button)
        
    }
    
    func loginUser (email: String, password: String) {
        
        backendless.userService.login(email, password: password, response: { (user:BackendlessUser!) -> Void in
            
            registerUserDeviceId()
            
            self.firebase.child("School").child(self.userUniversityID).child("Users").child(self.backendless.userService.currentUser.objectId).setValue(["name": self.backendless.userService.currentUser.name])
            
            self.performSegueWithIdentifier("goToMessages", sender: self)
            
        }) { (fault:Fault!) -> Void in
            print("\(fault)")
            
            self.presentViewController(self.signUpError!, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
        }
    }
}